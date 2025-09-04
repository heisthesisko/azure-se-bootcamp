Param(
  [string]$SubscriptionId = "",
  [string]$ResourceGroup = "rg-fhir-demo",
  [string]$Location = "eastus",
  [string]$FhirName = "fhir-demo-001",
  [string]$ApimName = "apim-fhir-demo",
  [string]$Sku = "Developer",
  [bool]$CreatePE = $true,
  [string]$VNet = "vnet-fhir",
  [string]$Subnet = "snet-private"
)

if ($SubscriptionId) { az account set --subscription $SubscriptionId }

az provider register --namespace Microsoft.HealthcareApis --wait
az provider register --namespace Microsoft.ApiManagement --wait
az provider register --namespace Microsoft.Logic --wait

az group create -n $ResourceGroup -l $Location | Out-Null

if ($CreatePE) {
  az network vnet create -g $ResourceGroup -n $VNet --address-prefixes 10.40.0.0/16 | Out-Null
  az network vnet subnet create -g $ResourceGroup --vnet-name $VNet -n $Subnet --address-prefixes 10.40.1.0/24 | Out-Null
}

az deployment group create -g $ResourceGroup `
  --template-file ./bicep/main.bicep `
  --parameters location=$Location fhirServiceName=$FhirName apimName=$ApimName skuName=$Sku `
               createPrivateEndpoint=$CreatePE vnetName=$VNet subnetName=$Subnet

az logic workflow create -g $ResourceGroup -n HL7toFHIR --location $Location `
  --definition @./logicapp/hl7_to_fhir_logicapp.json

$LaPid = az logic workflow show -g $ResourceGroup -n HL7toFHIR --query identity.principalId -o tsv
$FhirId = az resource show -g $ResourceGroup -n $FhirName --resource-type Microsoft.HealthcareApis/services --query id -o tsv

if ($LaPid -and $FhirId) {
  az role assignment create --assignee $LaPid --role "FHIR Data Contributor" --scope $FhirId | Out-Null
  az role assignment create --assignee $LaPid --role "FHIR Data Converter" --scope $FhirId | Out-Null
}

Write-Host "Done. FHIR endpoint: https://$FhirName.azurehealthcareapis.com"
