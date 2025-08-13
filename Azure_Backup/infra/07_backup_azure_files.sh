#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
SA="$STORAGE_ACCOUNT"
az storage account create -g "$RG_NAME" -n "$SA" -l "$AZ_LOCATION" --sku Standard_LRS --kind StorageV2
KEY=$(az storage account keys list -g "$RG_NAME" -n "$SA" --query "[0].value" -o tsv)
az storage share-rm create --storage-account "$SA" --name "ehrfiles" --quota 100
az backup protection enable-for-azurefileshare -g "$RG_NAME" -v "$RSV_NAME"   --storage-account "$SA" --azure-file-share "ehrfiles" --policy-name "AzureFileShareDefaultPolicy"
