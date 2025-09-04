// bicep/azureml.bicep
param workspaceName string = 'ImagingMLWorkspace'
param location string = resourceGroup().location

resource aml 'Microsoft.MachineLearningServices/workspaces@2023-04-01' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: workspaceName
    publicNetworkAccess: 'Disabled'
    encryption: {
      status: 'Enabled'
    }
  }
}

output workspaceId string = aml.id
