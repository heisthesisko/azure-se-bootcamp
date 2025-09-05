// iac/deploy_services.bicep
param location string = 'eastus'
param oaiName string
param searchName string
param pgServerName string
param kvName string

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard', family: 'A' }
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

resource oai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: oaiName
  location: location
  kind: 'OpenAI'
  sku: { name: 'S0' }
  properties: { customSubDomainName: toLower(oaiName) }
}

resource search 'Microsoft.Search/searchServices@2023-11-01' = {
  name: searchName
  location: location
  sku: { name: 'basic' }
  properties: {
    hostingMode: 'default'
    publicNetworkAccess: 'Disabled'
    networkRuleSet: { ipRules: [] }
  }
}

resource pg 'Microsoft.DBforPostgreSQL/flexibleServers@2023-03-01-preview' = {
  name: pgServerName
  location: location
  properties: {
    version: '15'
    network: { publicNetworkAccess: 'Disabled' }
    storage: { storageSizeGB: 32 }
    administratorLogin: 'dbadmin'
    administratorLoginPassword: 'ChangeMe!234' // replace via parameter/Key Vault in real use
    highAvailability: { mode: 'ZoneRedundant' }
  }
  sku: { name: 'Standard_B1ms', tier: 'Burstable', family: 'B', capacity: 1 }
}

output openAiId string = oai.id
output searchId string = search.id
output pgId string = pg.id
output kvId string = kv.id
