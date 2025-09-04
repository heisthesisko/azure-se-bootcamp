param location string = 'eastus'
param dataFactoryName string = 'ClinicalDataFactory'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}
