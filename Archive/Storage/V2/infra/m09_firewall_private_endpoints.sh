#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
ensure_vnet
ensure_private_dns

sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Denying public network access and creating a Private Endpoint for blob..."
az storage account update -g "$RG_NAME" -n "$sa" --default-action Deny -o none
pe_create_for_blob "$sa"
echo "Private Endpoint for blob created and DNS record set."
