#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ensure_rg
echo "Creating Azure Health Data Services workspace with FHIR and DICOM services..."
az healthcareapis workspace create -g "$RG_NAME" -n "$FHIR_WS" -l "$LOCATION" -o none || true
az healthcareapis fhir-service create -g "$RG_NAME" --workspace-name "$FHIR_WS" -n "$FHIR_SVC"   --kind "fhir-R4" -o none || true
az healthcareapis dicom-service create -g "$RG_NAME" --workspace-name "$FHIR_WS" -n "$DICOM_SVC" -o none || true

echo "Create ADLS Gen2 storage for downstream analytics exports (see module 16)."
sa=$(sa_name)
create_storage_account "$sa" "Standard_LRS" true

echo "Optionally set up export pipelines (Logic App/Azure Function) from FHIR to ADLS/Blob."
