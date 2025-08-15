#!/usr/bin/env bash
set -euo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${THIS_DIR}/common.sh"

ensure_rg
sa=$(sa_name)
echo "Creating Storage Account: $sa (Standard_LRS, GPv2)"
create_storage_account "$sa" "Standard_LRS" false

echo "Creating container 'phi' and uploading sample files (requires key auth)..."
key=$(az storage account keys list -g "$RG_NAME" -n "$sa" --query [0].value -o tsv)
az storage container create -n "${BLOB_CONTAINER:-phi}" --account-name "$sa" --account-key "$key" -o none

mkdir -p /tmp/hcws
echo "PatientID,Name,DOB,Diagnosis" > /tmp/hcws/patients.csv
echo "1001,Jane Doe,1980-02-01,Hypertension" >> /tmp/hcws/patients.csv
echo "1002,John Smith,1975-11-23,Type 2 Diabetes" >> /tmp/hcws/patients.csv

az storage blob upload -c "${BLOB_CONTAINER:-phi}" -f /tmp/hcws/patients.csv -n patients.csv   --account-name "$sa" --account-key "$key" -o none

echo "Generating a short-lived SAS for training uploads (write-only)..."
expiry=$(date -u -d "+2 hours" '+%Y-%m-%dT%H:%MZ' 2>/dev/null || date -u -v+2H '+%Y-%m-%dT%H:%MZ')
sas=$(az storage container generate-sas -n "${BLOB_CONTAINER:-phi}" --permissions acw --https-only       --expiry "$expiry" --account-name "$sa" --account-key "$key" -o tsv)
echo "BLOB_ACCOUNT=$sa"
echo "WEB_SAS=$sas"
