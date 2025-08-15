#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg; ensure_la
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
diag_to_la "$sa"
echo "Diagnostics configured for $sa to Log Analytics $LA_WORKSPACE."
