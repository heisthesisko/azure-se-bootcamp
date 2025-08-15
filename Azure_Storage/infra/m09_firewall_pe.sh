#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg; ensure_vnet
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az storage account update -g "$RG_NAME" -n "$sa" --default-action Deny -o none
az network private-endpoint create -g "$RG_NAME" -n "${sa}-pe-blob" --vnet-name "$VNET_NAME" --subnet "snet-privend"   --private-connection-resource-id "$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)"   --group-id blob --connection-name "${sa}-conn" -o none
az network private-dns zone create -g "$RG_NAME" -n "privatelink.blob.core.windows.net" -o none || true
az network private-dns link vnet create -g "$RG_NAME" -n "pdns-link" -z "privatelink.blob.core.windows.net" -v "$VNET_NAME" -e true -o none || true
echo "Firewall set to deny public; Private Endpoint created."
