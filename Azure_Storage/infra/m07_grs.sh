#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Switching redundancy to GRS (may incur cost)..."
az storage account update -g "$RG_NAME" -n "$sa" --sku Standard_GRS -o none
echo "Redundancy updated to GRS."
