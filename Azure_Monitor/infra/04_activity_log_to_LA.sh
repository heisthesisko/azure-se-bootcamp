#!/usr/bin/env bash
set -euo pipefail
source config/.env
SUBID=$(az account show --query id -o tsv)
LAW_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)
az monitor diagnostic-settings create --name SendActivityLogsToLA   --resource "/subscriptions/$SUBID" --workspace "$LAW_ID"   --logs '[{"category":"Administrative","enabled":true},{"category":"Security","enabled":true},{"category":"Policy","enabled":true},{"category":"Alert","enabled":true},{"category":"Recommendation","enabled":true}]'
echo "Activity Log forwarding enabled."
