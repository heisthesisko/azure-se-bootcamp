#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
ensure_kv

sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" false

echo "Creating a CMK in Key Vault..."
key_name="cmk-storage"
az keyvault key create --vault-name "$KEYVAULT_NAME" -n "$key_name" --kty RSA --size 2048 -o none
key_id=$(az keyvault key show --vault-name "$KEYVAULT_NAME" -n "$key_name" --query key.kid -o tsv)

echo "Granting Storage access to Key Vault (key permissions)..."
sa_principal=$(az storage account show -g "$RG_NAME" -n "$sa" --query "identity.principalId" -o tsv 2>/dev/null || true)
if [ -z "$sa_principal" ]; then
  az storage account update -g "$RG_NAME" -n "$sa" --assign-identity -o none
  sa_principal=$(az storage account show -g "$RG_NAME" -n "$sa" --query "identity.principalId" -o tsv)
fi
az keyvault set-policy -n "$KEYVAULT_NAME" --object-id "$sa_principal" --key-permissions get unwrapKey wrapKey -o none

echo "Configuring Storage to use CMK..."
az storage account update -g "$RG_NAME" -n "$sa"   --encryption-key-source Microsoft.Keyvault   --encryption-key-vault "$KEYVAULT_NAME"   --encryption-key-name "$key_name" -o none
echo "CMK encryption configured."
