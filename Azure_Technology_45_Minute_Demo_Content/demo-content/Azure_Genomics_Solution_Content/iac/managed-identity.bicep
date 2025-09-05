
param location string = 'eastus'
param identityName string = 'uami-cromwell'
param storageAccountId string
param batchAccountId string
param assignContributorToBatch bool = true

// Built-in role IDs
@description('Storage Blob Data Contributor')
param storageBlobDataContributorRoleId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

@description('Contributor (used for Batch unless a narrower role is provided)')
param contributorRoleId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource raStorage 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccountId, uami.properties.principalId, storageBlobDataContributorRoleId)
  scope: resourceId(subscription().subscriptionId, resourceGroup().name, 'Microsoft.Storage/storageAccounts', last(split(storageAccountId, '/')))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource raBatch 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (assignContributorToBatch) {
  name: guid(batchAccountId, uami.properties.principalId, contributorRoleId)
  scope: batchAccountId
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contributorRoleId)
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output identityId string = uami.id
output principalId string = uami.properties.principalId
