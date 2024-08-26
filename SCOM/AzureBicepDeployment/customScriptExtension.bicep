@description('Vm Name')
param vmName string

@description('location where the resource to be deployed')
param location string

@description('Uri for the script that is to be deployed')
param fileUri string

@description('Name of the file to be deployed')
param fileName string


resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' existing = {
  name: vmName
}

resource scriptExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  name: '${vmName}CustomScriptExtension'
  location: location
  parent: virtualMachine
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        fileUri
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File ${fileName}'
    }
  }
}
