#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
ensure_log_analytics
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false
set_sa_diagnostics "$sa"
echo "Diagnostics (logs/metrics) routed to Log Analytics for $sa."
