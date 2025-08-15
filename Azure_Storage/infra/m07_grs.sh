#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az storage account update -g "$RG_NAME" -n "$sa" --sku Standard_RAGRS -o none
echo "Set SKU to RA-GRS for read access on secondary."
