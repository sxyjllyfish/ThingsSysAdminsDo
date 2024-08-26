@description('Public IP name')
param PublicIpName string

@description('location')
param location string

@description('SKU Name')
param Sku string

@description('Tier')
param tier string

resource publicIP 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: PublicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: Sku
    tier: tier
  }
}

output publicIpId string = publicIP.id
