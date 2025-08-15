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
echo "[M04] Allocate standardized Public IPs for later modules"
az network public-ip create -g "$RG_NAME" -n "${PREFIX}-pip-lb" --sku Standard --dns-name "$LB_DNS_LABEL"
az network public-ip create -g "$RG_NAME" -n "${PREFIX}-pip-appgw" --sku Standard --dns-name "$APPGW_DNS_LABEL"
az network public-ip create -g "$RG_NAME" -n "${PREFIX}-pip-bastion" --sku Standard --dns-name "$BASTION_DNS_LABEL"
az network public-ip create -g "$RG_NAME" -n "${PREFIX}-pip-firewall" --sku Standard
echo "Public IPs created (LB, AppGW, Bastion, Firewall)."
