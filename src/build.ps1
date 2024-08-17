$containerRuntime = "docker"

$registryUrl = "cr.maks-it.com"  # Modify this line to set your registry URL
$imageName = "library/podman:latest"  # Modify this line to set your desired image name

param(
    [string]$ContainerRuntime = $containerRuntime
)

if ($ContainerRuntime -ne "docker" -and $ContainerRuntime -ne "podman") {
    Write-Host "Error: Unsupported container runtime. Use 'docker' or 'podman'." -ForegroundColor Red
    exit 1
}

$configFile = "$PSScriptRoot\config.json"

# Retrieve the auth value from the CR_MAKS_IT environment variable
$authValue = $env:CR_MAKS_IT

# Check if the CR_MAKS_IT environment variable is set and not empty
if (-not $authValue) {
    Write-Host "Error: Environment variable CR_MAKS_IT is not set or is empty." -ForegroundColor Red
    exit 1
}

# Create the JSON object
$json = @{
    auths = @{
        $registryUrl = @{
            auth = $authValue
        }
    }
} | ConvertTo-Json -Depth 10 -Compress:$false

# Write the JSON object to the config.json file with 2-space indentation
$jsonString = $json -replace "    ", "  "
$jsonString | Set-Content -Path $configFile

# Build the container image
& $ContainerRuntime build -t "$registryUrl/$ImageName" -f Dockerfile .

# Push the container image using the generated config.json
& $ContainerRuntime --config $configFile push "$registryUrl/$ImageName"

# Delete the config.json file after the push
Remove-Item -Path $configFile -Force

Write-Host "Build and push completed successfully." -ForegroundColor Green
