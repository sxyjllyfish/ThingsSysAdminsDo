# Connect to AzureAD
Connect-AzureAD

# Get all users with the email address ending in @intelematics.com.au
$users = Get-AzureADUser -All $true | Where-Object { $_.UserPrincipalName -like "*@intelematics.com.au" }

# Create an array to store unique applications
$uniqueApps = @()

# Iterate over each user and get their assigned applications
foreach ($user in $users) {
    # Get the applications assigned to the user
    $assignedApps = Get-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId

    foreach ($app in $assignedApps) {
        # Get the display name of the application
        $appDisplayName = (Get-AzureADServicePrincipal -ObjectId $app.ResourceId).DisplayName
        
        # Add to the array if it's not already present
        if (-not $uniqueApps -contains $appDisplayName) {
            $uniqueApps += $appDisplayName
        }
    }
}

# Export the unique applications to a CSV file
$uniqueApps | Sort-Object | Select-Object @{Name='ApplicationName';Expression={$_}} | Export-Csv -Path "UniqueAzureADApplications.csv" -NoTypeInformation

Write-Output "Unique applications have been exported to UniqueAzureADApplications.csv"
