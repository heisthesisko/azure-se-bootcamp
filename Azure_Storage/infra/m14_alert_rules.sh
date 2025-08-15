#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg; ensure_la

AG_NAME="ag-hc-ws"
AG_ID=$(az monitor action-group show -g "$RG_NAME" -n "$AG_NAME" --query id -o tsv)

LA_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LA_WORKSPACE" --query id -o tsv)

# 1) Scheduled query (Log) alert: Excessive blob deletes in 5 minutes
KQL=$(cat <<'KQL'
StorageBlobLogs
| where OperationName in ("DeleteBlob","DeleteContainer")
| summarize Deletes=count() by bin(TimeGenerated, 5m)
| where Deletes > 10
KQL
)

az monitor scheduled-query create   -g "$RG_NAME" -n "alert-blob-delete-spike"   --scopes "$LA_ID"   --description "High blob/container delete rate (>10/5m)"   --evaluation-frequency "PT5M"   --severity 2   --window-size "PT5M"   --action $AG_ID   --condition query="$KQL" time-aggregation="Count" operator="GreaterThan" threshold=0   -o none

# 2) Metric alert: Used capacity above 10 GB
SCOPE=$(az storage account list -g "$RG_NAME" --query "[0].id" -o tsv)
az monitor metrics alert create   -g "$RG_NAME" -n "alert-used-capacity-gt-10gb"   --scopes "$SCOPE"   --condition "avg UsedCapacity > 10000000000"   --description "Storage UsedCapacity > 10GB"   --window-size 5m --evaluation-frequency 5m   --severity 3 --action $AG_ID -o none

echo "Alert rules created. Ensure diagnostics are enabled and data is flowing."
