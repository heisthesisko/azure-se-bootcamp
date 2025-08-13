#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Switch storage redundancy; some changes restricted after items protected.
az backup vault backup-properties set -g "$RG_NAME" -n "$RSV_NAME" --storage-redundancy GeoRedundant
