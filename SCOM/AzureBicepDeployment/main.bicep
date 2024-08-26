targetScope='subscription'
@description('The location where the resources will be deployed')
param location string  = 'australiasoutheast'

module rgModule './rg.bicep' = {
  name:'ScomResourceGroup'
  params: {
    resourceGroupName: 'rg-aus-scom-test'
    resourceGroupLocation: location
  }
}

module vnetModule './vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: 'VNET-Test'
    vnetAddressPrefix: '10.100.0.0/24'
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    rgModule
  ]
}

module domainsubnet 'subnet.bicep' = {
  name:'DomainSubnet'
  params: {
    subnetName:'SN-Domain'
    subnetPrefix:'10.100.0.64/26'
    vnetName:'VNET-Test'
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    vnetModule
  ]
}

module scomsubnet 'subnet.bicep' = {
  name:'ScomSubnet'
  params: {
    subnetName:'SN-Scom'
    subnetPrefix:'10.100.0.128/26'
    vnetName:'VNET-Test'
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    vnetModule
  ]
}

module bastionSubnet 'subnet.bicep' = {
  name:'BastionSubnet'
  params: {
    subnetName:'SN-Bastion'
    subnetPrefix:'10.100.0.0/26'
    vnetName:'VNET-Test'
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    vnetModule
  ]
}

module BastionPublicIp './publicIp.bicep' = {
  name:'BastionPublicIp'
  params:{
    location:location
    PublicIpName: 'pip-BastionPublicIP'
    Sku:'Standard'
    tier:'Regional'
  }
  scope:resourceGroup('rg-aus-scom-test')
}

module BastionHost 'bastion.bicep' = {
  name:'BastionHost'
  params: {
    location:location
    name:'ScomBastion'
    SubnetID:bastionSubnet.outputs.subnetId
    PublicIpId:BastionPublicIp.outputs.publicIpId
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    bastionSubnet
    BastionPublicIp
  ]

}

module DcModule './vm.bicep' = {
  name: 'DomainController'
  params: {
    vmName: 'NPEWINSDC01'
    location: location
    vmSize: 'Standard_D2s_v3'
    adminUsername: 'infraops'
    adminPassword: 'F@1ryTail!N@tsuDR@gn33l!' // Replace with secure value
    //vnetId: vnetModule.outputs.vnetId
    subnetId: domainsubnet.outputs.subnetId
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    domainsubnet
  ]
}

module AddsModule './customScriptExtension.bicep' = {
  name: 'AddsDeployment'
  params: {
    fileUri: 'https://samorotech.blob.core.windows.net/deploymentscripts/Test/Test-Script.ps1'
    fileName: 'Test-Script.ps1'
    location: location
    vmName: 'NPEWINSDC01'
  }
  scope:resourceGroup('rg-aus-scom-test')
  dependsOn:[
    DcModule
    domainsubnet
  ]
}

//module CaModule './vm.bicep' = {
//  name: 'CertificateAuthority'
//  params: {
//    vmName: 'NPEWINSCA01'
//    location: location
//    vmSize: 'Standard_D2s_v3'
//    adminUsername: 'infraops'
//    adminPassword: 'F@1ryTail!N@tsuDR@gn33l!'

//    subnetId: domainsubnet.outputs.subnetId
//  }
//  scope:resourceGroup('rg-aus-scom-test')
//  dependsOn:[
//    domainsubnet
//  ]
//}

//module ScomModule './vm.bicep' = {
//  name: 'Scom'
//  params: {
//    vmName: 'NPESCOMMG01'
//    location: location
//    vmSize: 'Standard_D2s_v3'
//    adminUsername: 'infraops'
//    adminPassword: 'F@1ryTail!N@tsuDR@gn33l!'
//    subnetId: scomsubnet.outputs.subnetId
//  }
//  scope:resourceGroup('rg-aus-scom-test')
//  dependsOn:[
//    scomsubnet
//  ]
//}
