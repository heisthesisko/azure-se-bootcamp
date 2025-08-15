#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "phi" --account-name "$sa" --account-key "$key" -o none
dd if=/dev/urandom of=/tmp/blob100mb.bin bs=1M count=5 status=none
az storage blob upload -c phi -n cold.bin -f /tmp/blob100mb.bin --account-name "$sa" --account-key "$key" -o none
az storage blob set-tier --tier Cool -c phi -n cold.bin --account-name "$sa" --account-key "$key" -o none
az storage blob set-tier --tier Archive -c phi -n cold.bin --account-name "$sa" --account-key "$key" -o none
echo "Use rehydrate: az storage blob set-tier --rehydrate-priority High --tier Cool -c phi -n cold.bin"
