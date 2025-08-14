#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
echo "Creating Storage Sync Service..."
az storagesync create -g "$RG_NAME" -n "syncsvc-hc" -l "$LOCATION" -o none || true

echo "Creating GPv2 account and file share to sync with..."
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage share-rm create --resource-group "$RG_NAME" --storage-account "$sa" --name "ehr-sync" --quota 1024 -o none

echo "Creating Sync Group and Cloud Endpoint..."
az storagesync sync-group create -g "$RG_NAME" --storage-sync-service "syncsvc-hc" -n "ehrsg" -o none
az storagesync cloud-endpoint create -g "$RG_NAME" --storage-sync-service "syncsvc-hc"   --sync-group-name "ehrsg" -n "ehr-cloud" --storage-account "$sa" --azure-file-share-name "ehr-sync" -o none

echo "Install and register the Azure File Sync agent on your on-prem Windows Server (not automated here)."
