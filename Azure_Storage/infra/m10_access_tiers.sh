#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "phi" --account-name "$sa" --account-key "$key" -o none
echo "Uploading and setting tiers (Hot -> Cool -> Archive) ..."
echo "sample" > /tmp/sample.txt
az storage blob upload -f /tmp/sample.txt -c phi -n sample.txt --account-name "$sa" --account-key "$key" -o none
az storage blob set-tier --tier Cool -c phi -n sample.txt --account-name "$sa" --account-key "$key" -o none
az storage blob set-tier --tier Archive -c phi -n sample.txt --account-name "$sa" --account-key "$key" -o none
echo "To rehydrate from Archive, use --rehydrate-priority and wait completion."
