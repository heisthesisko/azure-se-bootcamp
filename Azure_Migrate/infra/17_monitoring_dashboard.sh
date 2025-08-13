#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
# Example workbook creation would use ARM template; emit guidance
echo "Create Azure Monitor workbook, alerts (KQL) referencing migrated resources."
