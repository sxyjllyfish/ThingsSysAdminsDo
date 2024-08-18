// =========== main.bicep ===========
targetScope = 'subscription'

//param subscriptionId string
param location string = 'AustraliaSouthEast'
param resourceGroupName string = 'RG-AUS-SCOM'
param vnetName string = 'VNET-SCOM-TEST'
param addressPrefix string = '10.50.0.0/16'
param subnet1Name string = 'SN-DOMAIN'
param subnet1Prefix string = '10.50.1.0/24'
param subnet2Name string = 'SN-SCOM'
param subnet2Prefix string = '10.50.2.0/24'
param bastionName string = 'myBastion'
param bastionSubnetPrefix string = '10.50.3.0/27'
param vmAdminUsername string = 'InfraOps'
param vmAdminPassword string = 'N@tsuDR@gn33l!F@1ryTail!'



resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  location: location
  name: resourceGroupName
}

module vnetModule './network.bicep' = {
  name: 'VnetDeployment'
  scope: resourceGroup
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnet1Name: subnet1Name
    subnet1Prefix: subnet1Prefix
    subnet2Name: subnet2Name
    subnet2Prefix: subnet2Prefix
    bastionName: bastionName
    bastionSubnetPrefix: bastionSubnetPrefix

  }
}

//Virtual Machines
module vmDomainController './virtualmachine.bicep' = {
  name: 'DomainController'
  scope: resourceGroup
  params: {
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    vmSize: 'Standard_B2S'
    vmName: 'NPEWINSDC01'
    vmSubnetIds: [resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'SN-DOMAIN')]
    vmImagePublisher: 'MicrosoftWindowsServer'
    vmImageoffer: 'WindowsServer'
    vmImageSku: '2022-Datacenter'
    vmImageVersion: 'latest'
  }
}

module vmCertificatAuthority './virtualmachine.bicep' = {
  name: 'CertificateAuthority'
  scope: resourceGroup
  params: {
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    vmSize: 'Standard_B2S'
    vmName: 'NPEWINSCA01'
    vmSubnetIds: [resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'SN-DOMAIN')]
    vmImagePublisher: 'MicrosoftWindowsServer'
    vmImageoffer: 'WindowsServer'
    vmImageSku: '2022-Datacenter'
    vmImageVersion: 'latest'
  }
}

module vmScomManagementServer './virtualmachine.bicep' = {
  name: 'ScomManagementServer'
  scope: resourceGroup
  params: {
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    vmSize: 'Standard_B2S'
    vmName: 'NPEWINSCA01'
    vmSubnetIds: [resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'SN-SCOM')]
    vmImagePublisher: 'MicrosoftWindowsServer'
    vmImageoffer: 'WindowsServer'
    vmImageSku: '2022-Datacenter'
    vmImageVersion: 'latest'
  }
}
