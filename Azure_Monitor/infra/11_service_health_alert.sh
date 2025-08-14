#!/usr/bin/env bash
set -euo pipefail
source config/.env
AG_ID=$(az monitor action-group show -g "$RG_NAME" -n "$ACTION_GROUP" --query id -o tsv)
az monitor activity-log alert create -n ServiceHealthAlert -g "$RG_NAME"   --scopes "/subscriptions/$SUBSCRIPTION_ID"   --condition category=ServiceHealth containsAny 'Incident' 'Maintenance'   --action-group "$AG_ID"
echo "Service Health alert created."
