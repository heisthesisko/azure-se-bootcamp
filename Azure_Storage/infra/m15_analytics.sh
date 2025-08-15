#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az storage account blob-service-properties update --account-name "$sa" --enable-versioning true --enable-change-feed true -o none
echo '{"enabled":true,"destination":"$inventory","rules":[{"name":"daily","enabled":true,"destination":"$inventory","definition":{"filters":{"blobTypes":["blockBlob"]},"format":"Parquet","schedule":"Daily","objectType":"Blob","include":["Name","Last-Modified","Content-Length","AccessTier"]}}]}' > /tmp/inventory.json
az storage account blob-inventory-policy create -g "$RG_NAME" -n "$sa" --policy "@/tmp/inventory.json" -o none || true
echo "Enabled versioning, change feed, inventory."
