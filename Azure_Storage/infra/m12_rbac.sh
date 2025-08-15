#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
scope=$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)
UPN="${1:-user@contoso.com}"
az role assignment create --assignee "$UPN" --role "Storage Blob Data Reader" --scope "$scope" -o none
echo "Assigned Storage Blob Data Reader to $UPN at $scope"
