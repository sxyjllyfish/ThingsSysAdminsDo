param location string
param vnetName string
param addressPrefix string
param subnet1Name string
param subnet1Prefix string
param subnet2Name string
param subnet2Prefix string
param bastionSubnetPrefix string
param bastionName string 

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
    ]
  }
}

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: 'pip-${bastionName}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name:'Standard'
    tier: 'Regional'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2024-01-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[2].id
          }
         publicIPAddress: {
            id: bastionPublicIP.id
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}


