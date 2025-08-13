#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
# Placeholder: Deploy Azure Health Data Services workspace & FHIR/DICOM services
echo "Deploy Health Data Services (FHIR/DICOM) via ARM/Bicep or portal per your subscription capabilities."
