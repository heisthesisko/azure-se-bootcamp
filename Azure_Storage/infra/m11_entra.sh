#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az identity create -g "$RG_NAME" -n "$UAMI_NAME" -l "$LOCATION" -o none || true
scope=$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)
uami_id=$(az identity show -g "$RG_NAME" -n "$UAMI_NAME" --query id -o tsv)
az role assignment create --assignee "$uami_id" --role "Storage Blob Data Contributor" --scope "$scope" -o none
echo "Grant given. From a VM with this identity, request token for https://storage.azure.com/ and call REST."
