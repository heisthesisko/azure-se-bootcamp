#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az storage blob service-properties update --account-name "$sa" --enable-restore-policy true --restore-days 7 --enable-delete-retention true --delete-retention-days 7 -o none
echo "Soft delete + point-in-time restore enabled"
