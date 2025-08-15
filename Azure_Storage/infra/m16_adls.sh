#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" true
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage fs create -n "research" --account-name "$sa" --account-key "$key" -o none
az storage fs access set -n "research" --acl "user::rwx,group::r-x,other::---" --account-name "$sa" --account-key "$key" -o none
echo "ADLS Gen2 created with filesystem 'research'."
