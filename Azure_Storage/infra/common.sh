#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${THIS_DIR}/.." && pwd)"

if [ -f "${ROOT_DIR}/config/.env" ]; then
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/config/.env"
else
  echo "Missing ${ROOT_DIR}/config/.env. Copy config/env.sample to config/.env" >&2
  exit 1
fi

az account show >/dev/null 2>&1 || { echo "Run az login"; exit 1; }
[ -n "${SUBSCRIPTION_ID:-}" ] && az account set --subscription "$SUBSCRIPTION_ID"

rand(){ tr -dc a-z0-9 </dev/urandom | head -c 6; }

ensure_rg(){ az group create -n "$RG_NAME" -l "$LOCATION" -o none; }

ensure_vnet(){
  az network vnet create -g "$RG_NAME" -n "$VNET_NAME"     --address-prefix "$VNET_CIDR"     --subnet-name "snet-app" --subnet-prefixes "$SUBNET_APP" -o none
  az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME"     -n "snet-privend" --address-prefixes "$SUBNET_PRIVEND"     --disable-private-endpoint-network-policies true -o none || true
}

ensure_la(){ az monitor log-analytics workspace create -g "$RG_NAME" -n "$LA_WORKSPACE" -l "$LOCATION" -o none || true; }

sa_name(){ echo "${STORAGE_PREFIX}$(rand)"; }

create_sa(){
  local name="$1"; local sku="$2"; local kind="${3:-StorageV2}"; local hns="${4:-false}"
  az storage account create -g "$RG_NAME" -n "$name" -l "$LOCATION"     --sku "$sku" --kind "$kind" --https-only true --min-tls-version TLS1_2     --allow-blob-public-access false --hns "$hns" -o none
}

diag_to_la(){
  local sa="$1"; local la_id
  la_id=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LA_WORKSPACE" --query id -o tsv)
  az monitor diagnostic-settings create --name "${sa}-diag"     --resource "$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)"     --workspace "$la_id"     --logs '[{"category":"StorageRead","enabled":true},{"category":"StorageWrite","enabled":true},{"category":"StorageDelete","enabled":true},{"category":"Transaction","enabled":true}]'     --metrics '[{"category":"AllMetrics","enabled":true}]' -o none
}
