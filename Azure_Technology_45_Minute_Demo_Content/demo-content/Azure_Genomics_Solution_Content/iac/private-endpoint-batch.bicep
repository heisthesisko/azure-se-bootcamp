param location string = 'eastus'
param vnetName string
param subnetName string
param batchAccountId string
@description('Batch Private Link groupId (discover with: az network private-link-resource list --id <batchAccountId>)')
param groupId string = 'batchAccount'
@description('Private DNS zone name for Batch')
param privateDnsZoneName string = 'privatelink.batch.azure.com'

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
}

resource zone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: 'batchLink'
  parent: zone
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

resource pe 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: 'pe-batch'
  location: location
  properties: {
    subnet: { id: '${vnet.id}/subnets/${subnetName}' }
    privateLinkServiceConnections: [
      {
        name: 'batch-conn'
        properties: {
          privateLinkServiceId: batchAccountId
          groupIds: [ groupId ]
        }
      }
    ]
  }
}

resource zoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: 'batchZoneGroup'
  parent: pe
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'batch'
        properties: {
          privateDnsZoneId: zone.id
        }
      }
    ]
  }
}