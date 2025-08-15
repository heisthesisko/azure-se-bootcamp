#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
gpv2=$(sa_name); create_sa "$gpv2" "Standard_LRS" "StorageV2" false
prem_blob=$(sa_name); az storage account create -g "$RG_NAME" -n "$prem_blob" -l "$LOCATION" --sku Premium_LRS --kind BlockBlobStorage --https-only true -o none
file_premium=$(sa_name); az storage account create -g "$RG_NAME" -n "$file_premium" -l "$LOCATION" --sku Premium_LRS --kind FileStorage --https-only true -o none
echo "Created: GPv2=$gpv2, Premium BlockBlobStorage=$prem_blob, Premium FileStorage=$file_premium"
