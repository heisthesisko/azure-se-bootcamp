#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Demonstrate REST API calls via az rest
az rest --method get --url "https://management.azure.com/subscriptions/$AZ_SUBSCRIPTION_ID/providers/Microsoft.RecoveryServices/vaults?api-version=2023-02-01"
