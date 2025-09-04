#requires -RunAsAdministrator
param(
  [string]$ResourceGroup = "ClinDataIntegrationRG",
  [string]$TenantId = "<TENANT_ID>",
  [string]$SubscriptionId = "<SUB_ID>",
  [string]$Location = "eastus"
)

Install-Module Az.ConnectedMachine -Force -Scope AllUsers
Connect-AzConnectedMachine -ResourceGroup $ResourceGroup -TenantId $TenantId `
  -SubscriptionId $SubscriptionId -Location $Location

Write-Host "Arc onboarding complete. Verify in Azure Portal: Azure Arc -> Servers."
