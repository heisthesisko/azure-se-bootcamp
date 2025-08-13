Param(
  [string]$ApplianceName = "AzureMigrateAppliance",
  [string]$SwitchName = "Default Switch"
)
Write-Host "This script guides the setup of the Azure Migrate appliance VM on Hyper-V."
Write-Host "Download the official appliance VHD from the Azure portal and import it into Hyper-V."
Write-Host "Then connect it to the specified virtual switch and power it on."
