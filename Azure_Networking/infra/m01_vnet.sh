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
echo "[M01] Create VNet (no subnets yet)"
az network vnet create -g "$RG_NAME" -n "$VNET_NAME" --address-prefixes "$VNET_CIDR"       --tags env="$TAG_ENV" module="m01_vnet"
echo "VNet created: $VNET_NAME"
