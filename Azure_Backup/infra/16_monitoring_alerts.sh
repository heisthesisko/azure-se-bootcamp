#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
az monitor log-analytics workspace create -g "$RG_NAME" -n "$WORKSPACE_NAME" -l "$AZ_LOCATION"
az monitor diagnostic-settings create -g "$RG_NAME" -n "rsv-diag" --resource "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.RecoveryServices/vaults/$RSV_NAME"   --workspace "/subscriptions/$AZ_SUBSCRIPTION_ID/resourcegroups/$RG_NAME/providers/microsoft.operationalinsights/workspaces/$WORKSPACE_NAME"   --logs '[{"category":"AzureBackupReport","enabled":true}]'
