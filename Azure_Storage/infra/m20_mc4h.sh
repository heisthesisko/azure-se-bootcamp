#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
az healthcareapis workspace create -g "$RG_NAME" -n "$FHIR_WS" -l "$LOCATION" -o none || true
az healthcareapis fhir-service create -g "$RG_NAME" --workspace-name "$FHIR_WS" -n "$FHIR_SVC" --kind "fhir-R4" -o none || true
az healthcareapis dicom-service create -g "$RG_NAME" --workspace-name "$FHIR_WS" -n "$DICOM_SVC" -o none || true
echo "FHIR and DICOM services created."
