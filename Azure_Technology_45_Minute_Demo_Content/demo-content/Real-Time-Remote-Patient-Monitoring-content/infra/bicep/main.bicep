
param location string
param iotHubName string
param laName string
param storageAccountName string
param keyVaultName string
param fhirWorkspaceName string
param fhirServiceName string
param funcAppName string

@description('Log Analytics workspace')
resource la 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: laName
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
  }
}

@description('Storage for ASA assets and general use')
resource st 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

@description('Azure Key Vault for CMK and secrets')
resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    enablePurgeProtection: true
    enableSoftDelete: true
    tenantId: subscription().tenantId
    sku: { name: 'standard', family: 'A' }
    enableRbacAuthorization: true
    publicNetworkAccess: 'Disabled'
  }
}

@description('IoT Hub (S1)')
resource ioth 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: iotHubName
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    publicNetworkAccess: 'Enabled' // For demo; lock down via PE after DNS is in place
    minTlsVersion: '1.2'
    features: 'None'
    ipFilterRules: []
  }
}

@description('Stream Analytics job (placeholder)')
resource asa 'Microsoft.StreamAnalytics/streamingjobs@2021-10-01-preview' = {
  name: 'asa-rpm-job'
  location: location
  properties: {
    sku: { name: 'Standard' }
    outputErrorPolicy: 'Stop'
    eventsLateArrivalMaxDelayInSeconds: 10
    eventsOutOfOrderMaxDelayInSeconds: 10
    dataLocale: 'en-US'
    compatibilityLevel: '1.2'
    // Inputs, outputs, and query to be configured post-deploy via CLI or portal
  }
}

@description('Function App on Linux - Consumption')
resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-func-rpm'
  location: location
  sku: { name: 'Y1', tier: 'Dynamic' }
  kind: 'functionapp'
  properties: {}
}

resource site 'Microsoft.Web/sites@2022-09-01' = {
  name: funcAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'python' }
        { name: 'WEBSITE_RUN_FROM_PACKAGE', value: '1' }
        { name: 'PYTHON_VERSION', value: '3.11' }
        // FHIR_URL to be set after the FHIR service URL is known
      ]
      linuxFxVersion: 'Python|3.11'
      minimumElasticInstanceCount: 0
    }
  }
}

@description('AHDS workspace + FHIR service')
resource ws 'Microsoft.HealthcareApis/workspaces@2022-06-01' = {
  name: fhirWorkspaceName
  location: location
  properties: {}
}

resource fhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2022-06-01' = {
  name: '${fhirWorkspaceName}/${fhirServiceName}'
  location: location
  properties: {
    kind: 'fhir-R4'
    accessPolicies: [] // Use RBAC roles instead
    authenticationConfiguration: {
      authority: 'https://login.microsoftonline.com/${subscription().tenantId}'
      audience: 'https://${fhirServiceName}.azurehealthcareapis.com'
      smartProxyEnabled: false
    }
    corsConfiguration: {
      origins: []
      headers: []
      methods: ['GET','POST','PUT','PATCH']
      maxAge: 0
      allowCredentials: false
    }
    exportConfiguration: {}
    importConfiguration: { enabled: false }
  }
  dependsOn: [ws]
}

@description('Diagnostic settings wiring to Log Analytics')
resource ds_ioth 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-iothub'
  scope: ioth
  properties: {
    workspaceId: la.id
    logs: [
      { category: 'Connections', enabled: true }
      { category: 'DeviceTelemetry', enabled: true }
      { category: 'C2DCommands', enabled: true }
      { category: 'D2CTwinOperations', enabled: true }
    ]
    metrics: [
      { category: 'AllMetrics', enabled: true }
    ]
  }
}
