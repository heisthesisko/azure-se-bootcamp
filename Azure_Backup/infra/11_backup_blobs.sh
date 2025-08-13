#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Enable blob soft delete + versioning as pre-req for point-in-time restore demos
az storage account blob-service-properties update -g "$RG_NAME" -n "$STORAGE_ACCOUNT" --enable-delete-retention true --delete-retention-days 7
az storage account blob-service-properties update -g "$RG_NAME" -n "$STORAGE_ACCOUNT" --enable-versioning true
