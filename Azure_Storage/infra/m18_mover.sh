#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
az storage-mover storage-mover create -g "$RG_NAME" -n "mover-hc" -l "$LOCATION" -o none || true
az storage-mover project create -g "$RG_NAME" --storage-mover-name "mover-hc" -n "migrate-ephi" -o none || true
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
dst_id=$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)
az storage-mover endpoint create-azure-storage-blob-container -g "$RG_NAME" --storage-mover-name "mover-hc" --name "dst" --container-name "phi" --storage-account-id "$dst_id" -o none || true
echo "Create agent VM and job definition to migrate NFS/SMB to Blob."
