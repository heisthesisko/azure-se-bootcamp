#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
ensure_rg
PLAN="plan-fhirproxy"
APP="app-fhirproxy-$RANDOM"

az appservice plan create -g "$RG_NAME" -n "$PLAN" --sku P1v3 --is-linux -l "$LOCATION" -o none
az webapp create -g "$RG_NAME" -p "$PLAN" -n "$APP" --runtime "DOTNET|8.0" -o none

# Enable managed identity
az webapp identity assign -g "$RG_NAME" -n "$APP" -o none
PRINCIPAL_ID=$(az webapp identity show -g "$RG_NAME" -n "$APP" --query principalId -o tsv)

# Configure app settings
az webapp config appsettings set -g "$RG_NAME" -n "$APP" --settings "FHIR_ENDPOINT=${FHIR_ENDPOINT}" -o none

# Zip deploy the FhirProxy app
pushd "$(dirname "${BASH_SOURCE[0]}")/.."/app/dotnet/FhirProxy >/dev/null
zip -r /tmp/fhirproxy.zip . >/dev/null
popd >/dev/null
az webapp deploy -g "$RG_NAME" -n "$APP" --src-path /tmp/fhirproxy.zip --type zip -o none

# Assign FHIR Data Contributor at FHIR service scope (requires AHDS deployment and RBAC)
FHIR_SCOPE=$(az healthcareapis fhir-service show -g "$RG_NAME" --workspace-name "$FHIR_WS" -n "$FHIR_SVC" --query id -o tsv)
az role assignment create --assignee-object-id "$PRINCIPAL_ID" --assignee-principal-type ServicePrincipal   --role "FHIR Data Contributor" --scope "$FHIR_SCOPE" -o none || true

echo "App Service deployed: $APP"
echo "Set up DNS/SSL as needed. Verify token acquisition and POST /ingest/patient"
