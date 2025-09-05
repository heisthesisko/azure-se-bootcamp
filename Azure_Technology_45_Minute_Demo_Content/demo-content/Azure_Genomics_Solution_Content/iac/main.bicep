param location string = 'eastus'
param storageAccountName string
param keyVaultName string
param synapseName string
param cmkName string = 'adls-cmk'
param fileSystem string = 'genomics'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { family: 'A', name: 'standard' }
    enablePurgeProtection: true
    enableSoftDelete: true
  }
}

resource key 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  name: '${keyVaultName}/${cmkName}'
  properties: { kty: 'RSA' }
}

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: { name: 'Standard_RAGRS' }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyVaultProperties: {
        keyName: cmkName
        keyVaultUri: kv.properties.vaultUri
      }
      services: { blob: { enabled: true } }
    }
    isHnsEnabled: true
    networkAcls: { defaultAction: 'Deny', bypass: 'AzureServices' }
  }
}

resource syn 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseName
  location: location
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'https://${storageAccountName}.dfs.core.windows.net'
      filesystem: fileSystem
    }
    managedVirtualNetwork: 'default'
    encryption: {
      cmk: {
        key: {
          name: cmkName
          keyVaultUrl: kv.properties.vaultUri
        }
      }
    }
  }
}