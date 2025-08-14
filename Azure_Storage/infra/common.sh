#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${THIS_DIR}/.." && pwd)"

# Load env
if [ -f "${ROOT_DIR}/config/.env" ]; then
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/config/.env"
else
  echo "Missing ${ROOT_DIR}/config/.env. Copy config/env.sample to config/.env and fill values." >&2
  exit 1
fi

# Basic checks
az account show > /dev/null 2>&1 || { echo "Run 'az login' first."; exit 1; }
if [ -n "${SUBSCRIPTION_ID:-}" ]; then
  az account set --subscription "$SUBSCRIPTION_ID"
fi

rand() {
  tr -dc a-z0-9 </dev/urandom | head -c 6
}

ensure_rg() {
  az group create -n "$RG_NAME" -l "$LOCATION" -o none
}

ensure_vnet() {
  az network vnet create -g "$RG_NAME" -n "$VNET_NAME"     --address-prefix "$VNET_CIDR"     --subnet-name "snet-workload" --subnet-prefixes "$SUBNET_WORKLOAD" -o none

  # Private Endpoint subnet without NSG policies
  az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME"     -n "snet-privend" --address-prefixes "$SUBNET_PRIVEND"     --disable-private-endpoint-network-policies true -o none
}

ensure_private_dns() {
  az network private-dns zone create -g "$PRIVATE_DNS_RG" -n "$PRIVATE_DNS_ZONE" -o none || true
  az network private-dns link vnet create -g "$PRIVATE_DNS_RG"     -n "${VNET_NAME}-link" -z "$PRIVATE_DNS_ZONE" -v "$VNET_NAME" -e true -o none || true
}

ensure_log_analytics() {
  az monitor log-analytics workspace create -g "$RG_NAME" -n "$LA_WORKSPACE" -l "$LOCATION" -o none || true
}

ensure_kv() {
  az keyvault create -g "$RG_NAME" -n "$KEYVAULT_NAME" -l "$LOCATION" -o none || true
}

sa_name() {
  local base="${STORAGE_PREFIX}$(rand)"
  echo "$base"
}

# Create GPv2 (ADLS Gen2 capable if --hns true) storage account with HTTPS only
create_storage_account() {
  local name="$1"
  local sku="$2"     # Standard_LRS / Standard_GRS / Standard_RAGRS / Premium_LRS / Standard_ZRS etc.
  local hns="$3"     # true/false hierarchical namespace (for ADLS Gen2)
  az storage account create -g "$RG_NAME" -n "$name" -l "$LOCATION"      --sku "$sku" --kind StorageV2 --https-only true      --min-tls-version TLS1_2      --allow-blob-public-access false      --hns "$hns" -o none
}

pe_create_for_blob() {
  local sa="$1"
  local pe_name="${sa}-pe-blob"
  az network private-endpoint create -g "$RG_NAME" -n "$pe_name"     --vnet-name "$VNET_NAME" --subnet "snet-privend"     --private-connection-resource-id "$(az storage account show -g "$RG_NAME" -n "$sa" --query 'id' -o tsv)"     --group-id blob     --connection-name "${pe_name}-conn" -o none

  local nic_id
  nic_id=$(az network private-endpoint show -g "$RG_NAME" -n "$pe_name" --query 'networkInterfaces[0].id' -o tsv)
  local priv_ip
  priv_ip=$(az network nic show --ids "$nic_id" --query "ipConfigurations[0].privateIpAddress" -o tsv)

  az network private-dns record-set a add-record -g "$PRIVATE_DNS_RG" -z "$PRIVATE_DNS_ZONE"       -n "${sa}" -a "$priv_ip" -o none || true
}

set_sa_diagnostics() {
  local sa="$1"
  local la_id
  la_id=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LA_WORKSPACE" --query id -o tsv)
  az monitor diagnostic-settings create     --name "${sa}-diag"     --resource "$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)"     --workspace "$la_id"     --logs '[{"category":"StorageRead","enabled":true},{"category":"StorageWrite","enabled":true},{"category":"StorageDelete","enabled":true},{"category":"BlobInventoryPolicyLogs","enabled":true},{"category":"Transaction","enabled":true}]'     --metrics '[{"category":"AllMetrics","enabled":true}]' -o none
}
