#!/usr/bin/env bash
# Mint a time-limited SAS for a container using the current Azure identity (supports Managed Identity in a VM/Pod).
# Requires: az CLI; the identity must have appropriate Storage roles (e.g., Storage Blob Data Contributor).

set -euo pipefail
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <resource-group> <storage-account> <container> [--hours 12]"
  exit 1
fi

RG="$1"; STG="$2"; CONTAINER="$3"; HOURS="${4:---hours 12}"

# Login (assumes 'az login --identity' in managed identity context or regular az login)
END=$(date -u -d "$(( ${HOURS#--hours } )) hours" '+%Y-%m-%dT%H:%MZ')

SAS=$(az storage container generate-sas \
  --account-name "$STG" \
  --name "$CONTAINER" \
  --auth-mode login \
  --as-user \
  --permissions rlwd \
  --expiry "$END" -o tsv)

echo "SAS token (valid until $END):"
echo "$SAS"
