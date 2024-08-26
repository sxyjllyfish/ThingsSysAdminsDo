#Install the AD DS feature
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment



Install-ADDSForest `
    -DomainName "sysadmin.local" `
    -SafeModeAdministratorPassword (ConvertTo-SecureString "longFac351" -AsPlainText -Force) `
    -InstallDns `
    -DomainMode Win2012R2 `
    -ForestMode Win2012R2 `
    -LogPath "C:\ADDS\Logs" `
    -SysvolPath "C:\ADDS\SYSVOL" `
    -Force
