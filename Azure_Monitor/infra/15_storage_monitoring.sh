#!/usr/bin/env bash
set -euo pipefail
source config/.env
RAND=$(printf "%04d" $RANDOM)
STOR=${STORAGE_NAME//${'{'}RANDOM_SUFFIX{'}'}/$RAND}
az storage account create -g "$RG_NAME" -n "$STOR" -l "$LOCATION" --sku Standard_LRS
STOR_ID=$(az storage account show -g "$RG_NAME" -n "$STOR" --query id -o tsv)
LAW_ID=$(az monitor log-analytics workspace show -g "$RG_NAME" -n "$LAW_NAME" --query id -o tsv)
az monitor diagnostic-settings create --name storlogs --resource "$STOR_ID" --workspace "$LAW_ID"   --logs '[{"category":"StorageRead","enabled":true},{"category":"StorageWrite","enabled":true},{"category":"StorageDelete","enabled":true}]'   --metrics '[{"category":"Transaction","enabled":true}]'
echo "Storage diagnostics enabled."
