#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

scope=$(az storage account show -g "$RG_NAME" -n "$sa" --query id -o tsv)
echo "Example: assign Storage Blob Data Reader to a user (replace with UPN)"
UPN="${1:-user@contoso.com}"
az role assignment create --assignee "$UPN" --role "Storage Blob Data Reader" --scope "$scope" -o none
echo "RBAC assignment created."
