#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
az backup vault create -g "$RG_NAME" -n "$RSV_NAME" -l "$AZ_LOCATION" --sku Standard
az backup vault backup-properties set -g "$RG_NAME" -n "$RSV_NAME" --soft-delete-feature-state Enabled
