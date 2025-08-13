#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Customer-managed keys (CMK) example via Key Vault (simplified)
az keyvault create -g "$RG_NAME" -n "$KEYVAULT_NAME" -l "$AZ_LOCATION"
KEYID=$(az keyvault key create --vault-name "$KEYVAULT_NAME" -n bkup-key --protection software --query key.kid -o tsv)
echo "Key created: $KEYID"
echo "Associate CMK at vault creation time in production. See module notes."
