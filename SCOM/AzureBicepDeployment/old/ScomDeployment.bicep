@description('VNet name')
param vnetName string = 'VNET-AUS-SCOM'

@description('Address prefix')
param vnetAddressPrefix string = '10.100.0.0/16'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '10.100.0.0/24'

@description('Subnet 1 Name')
param subnet1Name string = 'SN-SCOM'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '10.100.1.0/24'

@description('Subnet 2 Name')
param subnet2Name string = 'SN-DomainCore'

@description('Location for all resources.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
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
    ]
  }
}
