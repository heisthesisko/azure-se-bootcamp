param location string = 'eastus'
param vnetName string = 'ClinicalVNet'
param subnetName string = 'SqlMISubnet'

@secure()
param administratorLoginPassword string

param administratorLogin string = 'sqladmin'
param managedInstanceName string = 'clin-sqlmi-prod'
param vCores int = 8
param storageSizeInGB int = 512
param licenseType string = 'LicenseIncluded' // or 'BasePrice'
param minimalTlsVersion string = '1.2'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  parent: vnet
  name: subnetName
}

resource sqlmi 'Microsoft.Sql/managedInstances@2022-05-01-preview' = {
  name: managedInstanceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    subnetId: subnet.id
    vCores: vCores
    storageSizeInGB: storageSizeInGB
    licenseType: licenseType
    minimalTlsVersion: minimalTlsVersion
    publicDataEndpointEnabled: false
    timezoneId: 'UTC'
  }
}
