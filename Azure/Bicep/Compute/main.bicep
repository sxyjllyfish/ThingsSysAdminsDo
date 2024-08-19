@description('The location where the resources will be deployed')
param location string = resourceGroup().location

module vnetModule './vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: 'VNET-Test'
    vnetAddressPrefix: '10.100.0.0/24'
    subnetName: 'SN-TEST'
    subnetAddressPrefix: '10.100.0.64/26'
  }
}

module vmModule './vm.bicep' = {
  name: 'vmDeployment'
  params: {
    rgName: 'RG-AUS-SCOM'
    vmName: 'myWinVM'
    location: location
    vmSize: 'Standard_D2s_v3'
    adminUsername: 'azureuser'
    adminPassword: 'YourPasswordHere!' // Replace with secure value
    //vnetId: vnetModule.outputs.vnetId
    subnetId: vnetModule.outputs.subnetId
  }
}
