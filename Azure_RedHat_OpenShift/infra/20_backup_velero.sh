#!/usr/bin/env bash
set -euo pipefail
source config/.env
# Install Velero with Azure Blob backup location (requires velero CLI locally)
az group create -n "$VELERO_RG" -l "$LOCATION"
az storage account create -n "$STORAGE_ACCOUNT" -g "$VELERO_RG" -l "$LOCATION" --sku Standard_LRS --kind StorageV2
SA_KEY=$(az storage account keys list -g "$VELERO_RG" -n "$STORAGE_ACCOUNT" --query [0].value -o tsv)
az storage container create --name "$VELERO_BUCKET" --account-name "$STORAGE_ACCOUNT"
cat > credentials-velero <<CREDS
AZURE_SUBSCRIPTION_ID=${AZ_SUBSCRIPTION_ID}
AZURE_TENANT_ID=${AZ_TENANT_ID}
AZURE_CLIENT_ID=<sp-client-id>
AZURE_CLIENT_SECRET=<sp-client-secret>
CREDS
velero install \
  --provider azure \
  --plugins velero/velero-plugin-for-microsoft-azure:v1.7.0 \
  --bucket "$VELERO_BUCKET" \
  --secret-file ./credentials-velero \
  --backup-location-config resourceGroup="$VELERO_RG",storageAccount="$STORAGE_ACCOUNT"
echo "[OK] Velero install invoked."
