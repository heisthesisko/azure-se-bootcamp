#!/usr/bin/env bash
set -euo pipefail
# Usage: create-kv-secrets.sh <keyVaultName> <secretName> <value>
KV="$1"; SEC="$2"; VAL="$3"
az keyvault secret set --vault-name "$KV" --name "$SEC" --value "$VAL" >/dev/null
echo "✅ Created secret $SEC in $KV"
