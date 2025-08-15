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
echo "[M13] ExpressRoute - create circuit (CAUTION: may incur cost)"
az network express-route circuit create -g "$RG_NAME" -n "$ER_CIRCUIT" --bandwidth "$ER_BANDWIDTH"       --sku-tier "$ER_SKU_TIER" --sku-family "$ER_SKU_FAMILY" --allow-global-reach false --peering-location "$ER_PEERING_LOCATION"       --service-provider-name "Equinix" || true
az network express-route circuit show -g "$RG_NAME" -n "$ER_CIRCUIT" -o table || true
echo "ExpressRoute circuit requested. Coordinate with provider to complete provisioning."
