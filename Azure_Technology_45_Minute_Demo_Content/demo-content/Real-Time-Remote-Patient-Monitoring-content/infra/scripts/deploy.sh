#!/usr/bin/env bash
set -euo pipefail

SUB=${SUB:-""}
RG=${RG:-"rg-rpm-dev-eus2"}
LOC=${LOC:-"eastus2"}
IOTHUB_NAME=${IOTHUB_NAME:-"ioth-rpm-dev-eus2"}
LA_NAME=${LA_NAME:-"log-rpm-dev-eus2"}
SA_NAME=${SA_NAME:-"strpm$RANDOM$RANDOM"}
KV_NAME=${KV_NAME:-"kv-rpm-dev-$RANDOM"}
FHIR_WS=${FHIR_WS:-"ws-rpm-dev"}
FHIR_SVC=${FHIR_SVC:-"fhirrpmdev$RANDOM"}
FUNC_NAME=${FUNC_NAME:-"func-rpm-dev-eus2"}

[[ -n "$SUB" ]] && az account set -s "$SUB"

az group create -n "$RG" -l "$LOC"

az deployment group create -g "$RG" -f infra/bicep/main.bicep \
  -p location="$LOC" iotHubName="$IOTHUB_NAME" laName="$LA_NAME" \
     storageAccountName="$SA_NAME" keyVaultName="$KV_NAME" \
     fhirWorkspaceName="$FHIR_WS" fhirServiceName="$FHIR_SVC" funcAppName="$FUNC_NAME"

echo "Discovering IoT Hub groupIds for Private Endpoint..."
IOTHUB_ID=$(az iot hub show -n "$IOTHUB_NAME" --query id -o tsv)
az network private-link-resource list --id "$IOTHUB_ID" -o table

echo "Done. Create Private Endpoints with the correct --group-ids and wire Private DNS."
