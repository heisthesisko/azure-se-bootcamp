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
echo "[M02] Create subnets (web, app, db, mgmt, AzureFirewallSubnet, GatewaySubnet)"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "web" --address-prefixes "$SUBNET_WEB_CIDR"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "app" --address-prefixes "$SUBNET_APP_CIDR"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "db" --address-prefixes "$SUBNET_DB_CIDR"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "mgmt" --address-prefixes "$SUBNET_MGMT_CIDR"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "AzureFirewallSubnet" --address-prefixes "$SUBNET_AZFW_CIDR"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "GatewaySubnet" --address-prefixes "$SUBNET_GW_CIDR"
echo "[M02] (Optional) Create a Linux VM in 'web' subnet"
if [[ -f "$SSH_KEY_PATH" ]]; then
  az vm create -g "$RG_NAME" -n "${PREFIX}-vm-web-1" --image "Ubuntu2204"         --size "Standard_B2s" --admin-username "$ADMIN_USERNAME" --ssh-key-values "$SSH_KEY_PATH"         --subnet "web" --vnet-name "$VNET_NAME" --public-ip-sku Standard --nsg ""         --tags env="$TAG_ENV" module="m02_subnets"
  echo "VM created: ${PREFIX}-vm-web-1"
else
  echo "SSH key not found at $SSH_KEY_PATH; skipping VM creation."
fi
