#!/usr/bin/env bash
set -euo pipefail
# Example: grant Reader to a user at the RG scope
RG_ID=$(az group show -n rg-azmigrate-healthcare --query id -o tsv)
USER_UPN="$1"
az role assignment create --assignee "$USER_UPN" --role Reader --scope "$RG_ID"
echo "Assigned Reader to $USER_UPN on $RG_ID"
