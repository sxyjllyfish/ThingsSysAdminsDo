@description('The name of the virtual network')
param vnetName string = 'VNET-Test'

@description('The location where the resources will be deployed')
param location string = resourceGroup().location

@description('The address prefix for the virtual network')
param vnetAddressPrefix string = '10.100.0.0/24'


resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

output vnetId string = vnet.id
