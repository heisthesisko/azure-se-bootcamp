// bicep/storage.bicep
param storageAccountName string
param location string = resourceGroup().location

resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_RAGRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    encryption: {
      services: {
        blob: { enabled: true }
        file: { enabled: true }
      }
      keySource: 'Microsoft.Storage'
    }
    publicNetworkAccess: 'Disabled' // use Private Endpoints
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: '${storageAccountName}/default'
}

@description('DICOM container (immutability set via CLI script post-deploy)')
resource dicomContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccountName}/default/dicom'
  dependsOn: [ blobService ]
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountId string = sa.id
output containerName string = 'dicom'
