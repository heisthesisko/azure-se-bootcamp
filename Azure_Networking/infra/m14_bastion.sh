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
echo "[M14] Azure Bastion"
SUBNET_ID=$(az network vnet subnet show -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "mgmt" --query id -o tsv)
# Azure Bastion requires a dedicated subnet named 'AzureBastionSubnet' (rename mgmt or create new)
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "AzureBastionSubnet" --address-prefixes "10.10.50.0/27" || true
PIP_BASTION_ID=$(az network public-ip show -g "$RG_NAME" -n "${PREFIX}-pip-bastion" --query id -o tsv)
az network bastion create -g "$RG_NAME" -n "${PREFIX}-bastion" --public-ip-address "$PIP_BASTION_ID" --vnet-name "$VNET_NAME"
echo "Bastion deployed. Use the Portal to connect to ${PREFIX}-vm-web-1 via Bastion (no public IP on the VM)."
