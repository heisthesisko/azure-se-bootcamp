#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Example: assign Backup Operator to a user (replace UPN)
USER_UPN="${1:-someone@contoso.com}"
az role assignment create --assignee "$USER_UPN" --role "Backup Operator" --scope "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$RG_NAME"
