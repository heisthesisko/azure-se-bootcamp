#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "compliance" --account-name "$sa" --account-key "$key" -o none
az storage container immutability-policy create --account-name "$sa" --account-key "$key" --container-name "compliance" --period 30 --allow-protected-append-writes true -o none
echo "WORM policy created."
