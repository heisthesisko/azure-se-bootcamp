#!/usr/bin/env bash
set -euo pipefail

SUB=${SUB:-""}
RG=${RG:-"rg-fhir-demo"}
LOCATION=${LOCATION:-"eastus"}
FHIR=${FHIR:-"fhir-demo-001"}
APIM=${APIM:-"apim-fhir-demo"}
SKU=${SKU:-"Developer"}
CREATE_PE=${CREATE_PE:-"true"}
VNET=${VNET:-"vnet-fhir"}
SNET=${SNET:-"snet-private"}

if [[ -n "$SUB" ]]; then az account set --subscription "$SUB"; fi

az provider register --namespace Microsoft.HealthcareApis --wait
az provider register --namespace Microsoft.ApiManagement --wait
az provider register --namespace Microsoft.Logic --wait
az extension add --name healthcareapis || true
az extension add --name logic || true

az group create -n "$RG" -l "$LOCATION"

# Optional VNet/Subnet for Private Endpoint
if [[ "$CREATE_PE" == "true" ]]; then
  az network vnet create -g "$RG" -n "$VNET" --address-prefixes 10.40.0.0/16
  az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SNET" --address-prefixes 10.40.1.0/24
fi

az deployment group create -g "$RG" \
  --template-file ./bicep/main.bicep \
  --parameters location="$LOCATION" fhirServiceName="$FHIR" apimName="$APIM" skuName="$SKU" \
               createPrivateEndpoint=$CREATE_PE vnetName="$VNET" subnetName="$SNET"

# Logic App
az logic workflow create -g "$RG" -n HL7toFHIR --location "$LOCATION" \
  --definition @./logicapp/hl7_to_fhir_logicapp.json

# RBAC for Logic App -> FHIR
LA_PID=$(az logic workflow show -g "$RG" -n HL7toFHIR --query identity.principalId -o tsv || echo "")
FHIR_ID=$(az resource show -g "$RG" -n "$FHIR" --resource-type Microsoft.HealthcareApis/services --query id -o tsv)
if [[ -n "$LA_PID" && -n "$FHIR_ID" ]]; then
  az role assignment create --assignee "$LA_PID" --role "FHIR Data Contributor" --scope "$FHIR_ID" || true
  az role assignment create --assignee "$LA_PID" --role "FHIR Data Converter" --scope "$FHIR_ID" || true
fi

echo "Done. FHIR endpoint: https://${FHIR}.azurehealthcareapis.com"
