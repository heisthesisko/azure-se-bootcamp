#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage share-rm create --resource-group "$RG_NAME" --storage-account "$sa" --name "ehr-sync" --quota 1024 -o none
echo "NOTE: Azure File Sync requires Windows Server agent. This lab uses Linux-friendly rsync/AzCopy to demonstrate sync patterns."
