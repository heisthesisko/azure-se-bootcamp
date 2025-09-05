#!/usr/bin/env bash
set -euo pipefail
# Usage: rotate-sas-to-kv.sh <keyVaultName> <secretName> <resourceGroup> <storageAccount> <container> [--hours 24]
KV="$1"; SEC="$2"; RG="$3"; STG="$4"; CON="$5"; HOURS="${6:---hours 24}"

END=$(date -u -d "$(( ${HOURS#--hours } )) hours" '+%Y-%m-%dT%H:%MZ')
SAS=$(az storage container generate-sas --account-name "$STG" --name "$CON" --auth-mode login --as-user --permissions rlwd --expiry "$END" -o tsv)
az keyvault secret set --vault-name "$KV" --name "$SEC" --value "$SAS" >/dev/null
echo "✅ Rotated $SEC in $KV (expires $END)"
