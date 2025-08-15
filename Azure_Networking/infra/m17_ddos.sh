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
echo "[M17] DDoS Protection plan and attach to VNet"
az network ddos-protection create -g "$RG_NAME" -n "$DDOS_PLAN"
VNET_ID=$(az network vnet show -g "$RG_NAME" -n "$VNET_NAME" --query id -o tsv)
az network vnet update --ids "$VNET_ID" --ddos-protection-plan "$DDOS_PLAN" --enable-ddos-protection
echo "DDoS plan attached to VNet."
