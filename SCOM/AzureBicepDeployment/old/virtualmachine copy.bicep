param adminUsername string
param vmSize string
param vmName string
param vmSubnetIds array
param vmImagePublisher string
param vmImageoffer string
param vmImageSku string
param vmImageVersion string
param location string

@secure()
param adminPassword string

param osDiskType string

param nicName string

param vnet string

//resource networkInterfaces 'Microsoft.Network/networkInterfaces@2024-01-01' = [
//  for (subnetId, index) in vmSubnetIds:{
//    name: 'NIC-${vmName}-${index}'
//    location: location
//    properties:{
//      ipConfigurations: [
//        {
//          name: 'ipconfig0'
//          properties: {
//            subnet: {
//              id: subnetId
//            }
//            privateIPAllocationMethod: 'Dynamic'
//          }
//        }
//      ]
//    }
//  }
//]

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          
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
        managedDisk: {storageAccountType: osDiskType}
      }
      imageReference: {
        publisher: vmImagePublisher
        offer: vmImageoffer
        sku: vmImageSku
        version: vmImageVersion
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
    //networkProfile: {
    //  networkInterfaces: [
    //    for i in range(0, length(vmSubnetIds)):{
    //      id: networkInterfaces[i].id
    //    }
    //  ]
    //}
  }
}

//resource installADDS 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = if (vmName == 'NPEWINSDC01'){
//  name: '${vmName}-InstallADDS'
//  location: resourceGroup().location
//  properties:{
//    publisher: 'Microsoft.Compute'
//    type: 'CustomScriptExtension'
//    typeHandlerVersion: '1.10'
//    autoUpgradeMinorVersion: true
//   settings: {
//      fileUris: [
//        'https://raw.githubusercontent.com/sxyjllyfish/ThingsSysAdminsDo/main/ActiveDirectoryDomainServices/Configure-ADDS.ps1'
//      ]
//      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File Configure-ADDS.ps1'
//    }
//  }
//}

//resource deployAADS 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = if (vmName == 'NPEWINSDC01'){
//  parent: vm
//  name: 'AADSDeployment'
//  location: location
//  properties: {
//    source:{scriptUri: 'https://raw.githubusercontent.com/sxyjllyfish/ThingsSysAdminsDo/main/ActiveDirectoryDomainServices/Configure-ADDS.ps1'}
//  }
//}


