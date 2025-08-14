#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Enable Azure AD auth (no action required—enabled by default for RBAC)."
echo "Create a User Assigned Managed Identity and grant Storage Blob Data Contributor."
az identity create -g "$RG_NAME" -n "$UAMI_NAME" -l "$LOCATION" -o none
uami_id=$(az identity show -g "$RG_NAME" -n "$UAMI_NAME" --query id -o tsv)

echo "Assign RBAC role to the UAMI at the storage scope..."
scope=$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)
az role assignment create --assignee "$uami_id"   --role "Storage Blob Data Contributor" --scope "$scope" -o none

echo "Use MSI from VM/Function to request tokens for https://storage.azure.com/ and access blobs."
