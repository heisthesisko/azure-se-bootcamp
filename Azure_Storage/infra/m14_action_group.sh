#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
EMAIL="${1:-you@example.com}"
ensure_rg
az monitor action-group create -g "$RG_NAME" -n "ag-hc-ws"   --action email admin "$EMAIL" --short-name "hcag" -o none
echo "Action Group 'ag-hc-ws' created for $EMAIL"
