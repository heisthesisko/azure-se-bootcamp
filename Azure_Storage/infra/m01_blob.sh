#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name)
create_sa "$sa" "Standard_LRS" "StorageV2" false
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "phi" --account-name "$sa" --account-key "$key" -o none
echo "Hello,Blob" > /tmp/hello.txt
az storage blob upload -c phi -n hello.txt -f /tmp/hello.txt --account-name "$sa" --account-key "$key" -o none
expiry=$(date -u -d "+2 hours" '+%Y-%m-%dT%H:%MZ' 2>/dev/null || date -u -v+2H '+%Y-%m-%dT%H:%MZ')
sas=$(az storage container generate-sas -n phi --permissions racw --https-only --expiry "$expiry" --account-name "$sa" --account-key "$key" -o tsv)
echo "BLOB_ACCOUNT=$sa"
echo "WEB_SAS=$sas"
echo "BLOB_CONTAINER=phi"
