#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Enable Update Management (new: Azure Update Manager can be configured via az rest or portal)
echo "Configure guest OS updates via Azure Update Manager (see module for detailed steps)."
