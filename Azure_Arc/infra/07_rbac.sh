#!/usr/bin/env bash
set -euo pipefail


source config/.env
# Example: grant a user minimal read access to Arc servers RG
USER_UPN="user@example.com"
az role assignment create --assignee "$USER_UPN" --role "Reader" --scope "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$ARC_RG_SERVERS"
echo "Assigned Reader to $USER_UPN on $ARC_RG_SERVERS"
