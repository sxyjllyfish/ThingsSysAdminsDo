# Define the folder paths
$folders = @("C:\MoroTech", "C:\temp")

# Loop through each folder and create it if it doesn't exist
foreach ($folder in $folders) {
    if (-not (Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory
    }
    
    # Create the 'success.txt' file in the folder
    $filePath = Join-Path -Path $folder -ChildPath "success.txt"
    New-Item -Path $filePath -ItemType File -Force | Out-Null
}

Write-Output "Folders and files created successfully."
