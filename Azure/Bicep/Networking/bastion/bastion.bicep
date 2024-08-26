@description('Bastion Name')
param name string

@description('location')
param location string

@description('SubnetId')
param SubnetID string

@description('PublicIp Id')
param PublicIpId string

resource bastionHost 'Microsoft.Network/bastionHosts@2024-01-01' = {
  name: name
  location:location
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id:SubnetID
          }
          publicIPAddress: {
            id:PublicIpId
          }
        }
      }
    ]
  }
}

output bastionId string = bastionHost.id
