// iac/deploy_aro.bicep
// NOTE: For demo we show parameters; production should add private DNS and firewall rules
param location string = 'eastus'
param rgName string
param clusterName string = 'health-copilot-cluster'
param vnetName string = 'aro-vnet'
param masterSubnetName string = 'aro-master-subnet'
param workerSubnetName string = 'aro-worker-subnet'
param pullSecret string

resource aro 'Microsoft.RedHatOpenShift/openShiftClusters@2023-11-22-preview' = {
  name: clusterName
  location: location
  properties: {
    clusterProfile: {
      pullSecret: pullSecret
      domain: '${clusterName}.local'
      resourceGroupId: resourceGroup().id
    }
    servicePrincipalProfile: {
      // use managed identity in production
      clientId: '00000000-0000-0000-0000-000000000000'
      clientSecret: 'PLACEHOLDER'
    }
    networkProfile: {
      podCidr: '10.128.0.0/14'
      serviceCidr: '172.30.0.0/16'
    }
    masterProfile: {
      vmSize: 'Standard_D8s_v3'
      subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, masterSubnetName)
    }
    workerProfiles: [
      {
        name: 'worker'
        vmSize: 'Standard_D4s_v3'
        diskSizeGB: 128
        subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, workerSubnetName)
        count: 3
      }
    ]
    apiserverProfile: {
      visibility: 'Private'
    }
    ingressProfiles: [
      {
        name: 'default'
        visibility: 'Private'
      }
    ]
  }
}
