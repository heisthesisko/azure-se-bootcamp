#!/usr/bin/env bash
set -euo pipefail
source config/.env
az sql server create -l "$LOCATION" -g "$RG_NAME" -n "$AZ_SQL_SERVER" -u sqladmin -p 'P@ssw0rd1234!'
az sql db create -g "$RG_NAME" -s "$AZ_SQL_SERVER" -n "$AZ_SQL_DB" --service-objective S0
az monitor diagnostic-settings create --name sqllogs --resource "$(az sql db show -g "$RG_NAME" -s "$AZ_SQL_SERVER" -n "$AZ_SQL_DB" --query id -o tsv)"   --workspace "$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)"   --logs '[{"category":"SQLInsights","enabled":true},{"category":"AutomaticTuning","enabled":true},{"category":"QueryStoreRuntimeStatistics","enabled":true},{"category":"Errors","enabled":true}]'
echo "SQL diagnostics to Log Analytics enabled."
