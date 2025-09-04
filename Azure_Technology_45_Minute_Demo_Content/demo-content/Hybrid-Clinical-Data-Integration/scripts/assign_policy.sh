#!/usr/bin/env bash
set -euo pipefail

SUB="${1:-<SUB_ID>}"
RG="${2:-ClinDataIntegrationRG}"
GUID="a169a624-5599-4385-a696-c8d643089fab"   # HIPAA/HITRUST initiative

SCOPE="/subscriptions/$SUB/resourceGroups/$RG"
az policy assignment create --name hipaa-hitrust --display-name "HIPAA/HITRUST baseline" \
  --policy $GUID --scope $SCOPE
