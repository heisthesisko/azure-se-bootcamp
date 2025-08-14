#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
# Create Key Vault and set policy
az keyvault create -g "$AZ_RG" -n "$AZ_KV_NAME" -l "$AZ_LOCATION" --enable-purge-protection true --enable-soft-delete true
az keyvault set-policy -n "$AZ_KV_NAME" --key-permissions get wrapKey unwrapKey create --spn $(az account show --query user.name -o tsv || echo "")
# Disk Encryption Set (CMK) example (simplified)
KEY_NAME="disk-key"
az keyvault key create --vault-name "$AZ_KV_NAME" -n "$KEY_NAME" --protection software
echo "Key Vault and key created (CMK) - integrate with Disk Encryption Set as needed."
