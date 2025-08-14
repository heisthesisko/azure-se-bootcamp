#!/usr/bin/env bash
set -euo pipefail
[ -f config/.env ] && source config/.env || source config/env.sample
az backup vault create -g "$AZ_RG" -n "$AZ_RSV_NAME" -l "$AZ_LOCATION"
az backup protection enable-for-vm --vault-name "$AZ_RSV_NAME" -g "$AZ_RG" --vm "$AZ_VM1_NAME" --policy-name "DefaultPolicy"
echo "Backup enabled for $AZ_VM1_NAME in vault $AZ_RSV_NAME."
