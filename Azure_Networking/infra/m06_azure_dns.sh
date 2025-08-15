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
echo "[M06] Azure DNS - create public zone and A record for App Gateway"
ZONE="${PREFIX}.training"
az network dns zone create -g "$RG_NAME" -n "$ZONE"
PIP_APPGW=$(az network public-ip show -g "$RG_NAME" -n "${PREFIX}-pip-appgw" --query ipAddress -o tsv)
az network dns record-set a add-record -g "$RG_NAME" -z "$ZONE" -n "app" -a "$PIP_APPGW"
echo "Public DNS zone $ZONE created with 'app.$ZONE' -> $PIP_APPGW"
