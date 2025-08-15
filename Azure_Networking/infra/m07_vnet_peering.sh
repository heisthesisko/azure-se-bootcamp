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
echo "[M07] Create secondary VNet and set up peering"
VNET2="${PREFIX}-vnet2"
az network vnet create -g "$RG_NAME" -n "$VNET2" --address-prefixes "10.20.0.0/16"
az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET2" -n "web" --address-prefixes "10.20.10.0/24"
az network vnet peering create -g "$RG_NAME" -n "${PREFIX}-peer-v1-to-v2" --vnet-name "$VNET_NAME"       --remote-vnet "$VNET2" --allow-vnet-access --allow-forwarded-traffic
az network vnet peering create -g "$RG_NAME" -n "${PREFIX}-peer-v2-to-v1" --vnet-name "$VNET2"       --remote-vnet "$VNET_NAME" --allow-vnet-access --allow-forwarded-traffic
echo "Peering established between $VNET_NAME and $VNET2"
