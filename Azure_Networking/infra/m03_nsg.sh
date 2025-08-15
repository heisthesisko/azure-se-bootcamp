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
echo "[M03] Create NSG and rules for 'web' subnet"
NSG_NAME="${PREFIX}-web-nsg"
az network nsg create -g "$RG_NAME" -n "$NSG_NAME"
MY_IP=$(curl -s https://ifconfig.me || echo "0.0.0.0")
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" -n "AllowSSHMyIP"       --priority 100 --source-address-prefixes "$MY_IP" --destination-port-ranges 22       --direction Inbound --access Allow --protocol Tcp --description "Allow SSH from my IP"
az network nsg rule create -g "$RG_NAME" --nsg-name "$NSG_NAME" -n "AllowHTTP"       --priority 110 --source-address-prefixes "*" --destination-port-ranges 80       --direction Inbound --access Allow --protocol Tcp --description "Allow HTTP"
az network vnet subnet update -g "$RG_NAME" --vnet-name "$VNET_NAME" --name "web"       --network-security-group "$NSG_NAME"
echo "NSG associated to subnet 'web'."
