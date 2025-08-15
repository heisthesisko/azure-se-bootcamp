#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
sa=$(sa_name); create_sa "$sa" "Standard_LRS" "StorageV2" false
az keyvault create -g "$RG_NAME" -n "$KEYVAULT_NAME" -l "$LOCATION" -o none || true
az keyvault key create --vault-name "$KEYVAULT_NAME" -n "cmk-storage" --kty RSA --size 2048 -o none
az storage account update -g "$RG_NAME" -n "$sa" --assign-identity -o none
principal=$(az storage account show -g "$RG_NAME" -n "$sa" --query identity.principalId -o tsv)
az keyvault set-policy -n "$KEYVAULT_NAME" --object-id "$principal" --key-permissions get wrapKey unwrapKey -o none
az storage account update -g "$RG_NAME" -n "$sa" --encryption-key-source Microsoft.Keyvault --encryption-key-vault "$KEYVAULT_NAME" --encryption-key-name cmk-storage -o none
echo "CMK configured."
