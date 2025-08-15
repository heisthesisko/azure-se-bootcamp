#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [[ ! -f "$ROOT_DIR/config/.env" ]]; then
  echo "config/.env not found. Copy config/env.sample -> config/.env and set values."
  exit 1
fi
# shellcheck disable=SC1091
source "$ROOT_DIR/config/.env"
az account set --subscription "$SUBSCRIPTION_ID"
echo "[M20] Azure Health Data Services (FHIR + DICOM) with Private Endpoints"
az extension add --name healthcareapis || true
# Workspace
az healthcareapis workspace create -g "$RG_NAME" -n "${PREFIX}-ahds" -l "$LOCATION"
# FHIR service
az healthcareapis service fhir create -g "$RG_NAME" --workspace-name "${PREFIX}-ahds" -n "${PREFIX}-fhir" --kind "fhir-R4" --cosmos-offer-throughput 1000
# DICOM service
az healthcareapis service dicom create -g "$RG_NAME" --workspace-name "${PREFIX}-ahds" -n "${PREFIX}-dicom"
# Private Endpoints (FHIR)
SUBNET_WEB_ID=$(az network vnet subnet show -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "web" --query id -o tsv)
FHIR_ID=$(az healthcareapis service fhir show -g "$RG_NAME" --workspace-name "${PREFIX}-ahds" -n "${PREFIX}-fhir" --query id -o tsv)
DICOM_ID=$(az healthcareapis service dicom show -g "$RG_NAME" --workspace-name "${PREFIX}-ahds" -n "${PREFIX}-dicom" --query id -o tsv)
az network private-dns zone create -g "$RG_NAME" -n "privatelink.azurehealthcareapis.com"
VNET_ID=$(az network vnet show -g "$RG_NAME" -n "$VNET_NAME" --query id -o tsv)
az network private-dns link vnet create -g "$RG_NAME" -n "${PREFIX}-ahdslink" --zone-name "privatelink.azurehealthcareapis.com" --virtual-network "$VNET_ID" --registration-enabled false
az network private-endpoint create -g "$RG_NAME" -n "${PREFIX}-pe-fhir" --subnet "$SUBNET_WEB_ID" --private-connection-resource-id "$FHIR_ID" --group-id "fhir"
az network private-endpoint create -g "$RG_NAME" -n "${PREFIX}-pe-dicom" --subnet "$SUBNET_WEB_ID" --private-connection-resource-id "$DICOM_ID" --group-id "dicom"
echo "AHDS FHIR & DICOM services created with Private Endpoints."
