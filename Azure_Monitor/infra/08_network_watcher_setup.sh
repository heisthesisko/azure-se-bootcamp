#!/usr/bin/env bash
set -euo pipefail
source config/.env
az network watcher configure -g "$RG_NAME" --locations "$LOCATION" --enabled true
echo "Network Watcher enabled."
