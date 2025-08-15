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
echo "[M09] Deploy Azure Firewall"
# Public IP for Firewall created in M04
PIP_ID=$(az network public-ip show -g "$RG_NAME" -n "${PREFIX}-pip-firewall" --query id -o tsv)
az network firewall create -g "$RG_NAME" -n "${PREFIX}-azfw" --virtual-hub "" --enable-dns-proxy false
az network firewall ip-config create -g "$RG_NAME" -f "${PREFIX}-azfw" -n "azureFirewallIpConfig"       --public-ip-address "$PIP_ID" --vnet-name "$VNET_NAME"
# Get private IP
FW_IP=$(az network firewall show -g "$RG_NAME" -n "${PREFIX}-azfw" --query "ipConfigurations[0].privateIpAddress" -o tsv || echo "10.10.254.4")
echo "Firewall private IP: $FW_IP"
# Update UDR next hop
RT_NAME="${PREFIX}-rt-web"
az network route-table route update -g "$RG_NAME" --route-table-name "$RT_NAME" -n "DefaultToFirewall"       --next-hop-ip-address "$FW_IP"
echo "Azure Firewall deployed and route updated."
