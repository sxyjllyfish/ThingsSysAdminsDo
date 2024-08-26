@description('Name of existing Virtual Network')
param vnetName string

@description('Name of new subnet')
param subnetName string

@description('Address prefix for the new subnet')
param subnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
  }
}

output subnetId string = subnet.id
