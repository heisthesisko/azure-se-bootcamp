#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${THIS_DIR}/common.sh"

ensure_rg
sa=$(sa_name)
echo "Creating Storage Account: $sa with Files support (Standard_LRS)"
create_storage_account "$sa" "Standard_LRS" false

echo "Creating Azure File share 'ehr-files'..."
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage share-rm create --resource-group "$RG_NAME" --storage-account "$sa" --name "ehr-files"   --quota 100 -o none

echo "Connection info (SMB):"
echo "  SMB Path: \\${sa}.file.core.windows.net\ehr-files"
echo "  Username: AZURE\${sa}"
echo "  Key: $key"
