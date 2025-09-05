param uamiId string
param federatedName string = 'fid-cromwell'
param oidcIssuer string
param serviceAccountNamespace string
param serviceAccountName string
param audience string = 'api://AzureADTokenExchange'

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  id: uamiId
}

resource fic 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: '${uami.name}/${federatedName}'
  properties: {
    issuer: oidcIssuer
    subject: 'system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}'
    audiences: [ audience ]
  }
}

output clientId string = uami.properties.clientId
output principalId string = uami.properties.principalId