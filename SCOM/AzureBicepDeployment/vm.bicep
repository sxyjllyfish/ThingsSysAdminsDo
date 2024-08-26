@description('The name of the virtual machine')
param vmName string

@description('The location where the resources will be deployed')
param location string 

@description('The size of the virtual machine')
param vmSize string

@description('The admin username for the VM')
param adminUsername string 

@description('The admin password for the VM')
@secure()
param adminPassword string

@description('The ID of the existing subnet')
param subnetId string

@description('The OS disk type')
param osDiskType string = 'Standard_LRS'

@description('The public IP address name')
param publicIpName string = '${vmName}-pip'

@description('The network interface name')
param nicName string = '${vmName}-nic'

@description('The OS version')
var windowsOSVersion = '2022-Datacenter-Core'

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

resource nic 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
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
