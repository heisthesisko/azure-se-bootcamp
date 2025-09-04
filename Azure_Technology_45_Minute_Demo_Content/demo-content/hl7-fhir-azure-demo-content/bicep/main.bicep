
param location string = 'eastus'
param fhirServiceName string
param apimName string
@allowed([ 'Consumption' 'Developer' 'Basic' 'Standard' 'Premium' ])
param skuName string = 'Developer'

@description('Create Private Endpoint for FHIR (requires VNet/subnet).')
param createPrivateEndpoint bool = true
param vnetName string = 'vnet-fhir'
param subnetName string = 'snet-private'
param publicNetworkAccess string = 'Disabled' // 'Enabled' for quick tests

resource fhir 'Microsoft.HealthcareApis/services@2021-11-01' = {
  name: fhirServiceName
  location: location
  kind: 'fhir-R4'
  properties: {
    accessPolicies: [] // use RBAC roles instead
    authenticationConfiguration: {
      authority: 'https://login.microsoftonline.com/${tenant().tenantId}'
      audience: 'https://${fhirServiceName}.azurehealthcareapis.com'
      smartProxyEnabled: true
    }
    corsConfiguration: {
      origins: [
        'https://portal.azure.com'
      ]
      headers: [ '*' ]
      methods: [ 'GET', 'POST', 'PUT', 'DELETE', 'PATCH' ]
      maxAge: 1440
      allowCredentials: true
    }
    publicNetworkAccess: publicNetworkAccess
  }
}

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apimName
  location: location
  sku: { name: skuName, capacity: 1 }
  properties: {
    publisherName: 'HealthCo IT'
    publisherEmail: 'itadmin@healthco.com'
    virtualNetworkType: 'None' // For production consider External or Internal + Private Link
    publicIPAddresses: []
  }
}

@allowed([ 'Global' ])
param privateDNSZoneName string = 'privatelink.azurehealthcareapis.com'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
}
resource snet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  parent: vnet
  name: subnetName
}

resource peFhir 'Microsoft.Network/privateEndpoints@2022-09-01' = if (createPrivateEndpoint) {
  name: 'pe-${fhirServiceName}'
  location: location
  properties: {
    subnet: { id: snet.id }
    privateLinkServiceConnections: [
      {
        name: 'plink-fhir'
        properties: {
          privateLinkServiceId: fhir.id
          groupIds: [ 'FHIR' ]
          requestMessage: 'Private access to FHIR service'
        }
      }
    ]
  }
}

resource pzFhir 'Microsoft.Network/privateDnsZones@2018-09-01' = if (createPrivateEndpoint) {
  name: privateDNSZoneName
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = if (createPrivateEndpoint) {
  name: '${pzFhir.name}/link-${vnet.name}'
  properties: {
    registrationEnabled: false
    virtualNetwork: { id: vnet.id }
  }
}

resource pezFhir 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = if (createPrivateEndpoint) {
  name: '${peFhir.name}/pdzg-fhir'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config'
        properties: {
          privateDnsZoneId: pzFhir.id
        }
      }
    ]
  }
}

output fhirEndpoint string = 'https://${fhirServiceName}.azurehealthcareapis.com'
