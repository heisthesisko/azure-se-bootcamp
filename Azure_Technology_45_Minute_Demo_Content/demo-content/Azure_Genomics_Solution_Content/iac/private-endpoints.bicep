
param location string = 'eastus'
param vnetName string
param subnetName string
param storageAccountId string
param storageAccountName string
param dnsRgName string = resourceGroup().name

// Private DNS zones for Blob & DFS
resource dnsBlob 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.blob.core.windows.net'
  location: 'global'
}
resource dnsDfs 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.dfs.core.windows.net'
  location: 'global'
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
}

// Link DNS to VNet
resource linkBlob 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: 'blobLink'
  parent: dnsBlob
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}
resource linkDfs 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: 'dfsLink'
  parent: dnsDfs
  properties: {
    virtualNetwork: { id: vnet.id }
    registrationEnabled: false
  }
}

// Private Endpoint for Blob
resource peBlob 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: 'pe-blob'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'blob-conn'
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [ 'blob' ]
        }
      }
    ]
  }
}

// Private Endpoint for DFS (Data Lake)
resource peDfs 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: 'pe-dfs'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'dfs-conn'
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [ 'dfs' ]
        }
      }
    ]
  }
}

// A-records for Private Endpoints
resource arecBlob 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${storageAccountName}.blob.core.windows.net'
  parent: dnsBlob
  properties: {
    ttl: 300
    aRecords: [
      { ipv4Address: peBlob.properties.customDnsConfigs[0].ipAddresses[0] }
    ]
  }
}

resource arecDfs 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${storageAccountName}.dfs.core.windows.net'
  parent: dnsDfs
  properties: {
    ttl: 300
    aRecords: [
      { ipv4Address: peDfs.properties.customDnsConfigs[0].ipAddresses[0] }
    ]
  }
}
