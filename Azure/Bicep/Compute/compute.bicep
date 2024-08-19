@description('The name of the resource group')
param rgName string = 'RG-AUS-SCOM'

@description('The name of the virtual machine')
param vmName string = 'myWinVM'

@description('The location where the resources will be deployed')
param location string = resourceGroup().location

@description('The size of the virtual machine')
param vmSize string = 'Standard_D2s_v3'

@description('The admin username for the VM')
param adminUsername string = 'azureuser'

@description('The admin password for the VM')
@secure()
param adminPassword string = 'F@1ryTail!N@tsuDR@gn33l!'

@description('The name of the virtual network')
param vnetName string = 'VNET-Test'

@description('The address prefix for the virtual network')
param vnetAddressPrefix string = '10.100.0.0/24'

@description('The name of the subnet')
param subnetName string = 'SN-TEST'

@description('The address prefix for the subnet')
param subnetAddressPrefix string = '10.100.0.64/26'

@description('The OS disk type')
param osDiskType string = 'Standard_LRS'

@description('The public IP address name')
param publicIpName string = '${vmName}-pip'

@description('The network interface name')
param nicName string = '${vmName}-nic'

@description('The OS version')
var windowsOSVersion = '2022-Datacenter-Core'

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
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
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output vmId string = vm.id
