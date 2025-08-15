#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[M11] Application Gateway (WAF_v2) in front of web VMs"
SUBNET_APP_ID=$(az network vnet subnet show -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "app" --query id -o tsv)
PIP_APPGW_ID=$(az network public-ip show -g "$RG_NAME" -n "${PREFIX}-pip-appgw" --query id -o tsv)
az network application-gateway create -g "$RG_NAME" -n "${PREFIX}-appgw"       --sku WAF_v2 --capacity 2 --http-settings-protocol Http       --public-ip-address "$PIP_APPGW_ID" --vnet-name "$VNET_NAME" --subnet "app"
# Backend pool to the two web VMs private IPs
for i in 1 2; do
  IP=$(az vm list-ip-addresses -g "$RG_NAME" -n "${PREFIX}-vm-web-$i" --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
  az network application-gateway address-pool create -g "$RG_NAME" --gateway-name "${PREFIX}-appgw" -n "pool-$i" --servers "$IP"
done
# Listener, rule, and WAF policy is default on WAF_v2
echo "Application Gateway deployed. Test via: http://$APPGW_DNS_LABEL.$LOCATION.cloudapp.azure.com/"
