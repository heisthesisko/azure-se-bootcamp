#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Enabling blob soft delete (7 days) and container soft delete..."
az storage blob service-properties update --account-name "$sa"   --delete-retention true --delete-retention-period 7 -o none
az storage container-rm soft-delete -g "$RG_NAME" --storage-account "$sa" --enable true   --retention-days 7 -o none || true
echo "Soft delete configured on $sa."
