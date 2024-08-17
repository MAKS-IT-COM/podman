#!/bin/bash

# Define default container runtime and image name
containerRuntime="docker"

registryUrl="cr.maks-it.com"  # Modify this line to set your registry URL
imageName="library/podman:latest"  # Modify this line to set your desired image name

# Parse command-line arguments for --container-runtime flag only
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --container-runtime) containerRuntime="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Validate the container runtime option
if [[ "$containerRuntime" != "docker" && "$containerRuntime" != "podman" ]]; then
  echo "Error: Unsupported container runtime. Use 'docker' or 'podman'."
  exit 1
fi

configFile="$(pwd)/config.json"

# Retrieve the auth value from the CR_MAKS_IT environment variable
# Ensure that the CR_MAKS_IT variable is set and not empty
if [ -z "$CR_MAKS_IT" ]; then
  echo "Environment variable CR_MAKS_IT is not set."
  exit 1
fi

authValue="$CR_MAKS_IT"

# Create the JSON object
json=$(cat <<EOF
{
  "auths": {
    "$registryUrl": {
      "auth": "$authValue"
    }
  }
}
EOF
)

# Write the JSON object to the config.json file with 2-space indentation
echo "$json" > "$configFile"

# Build the container image
$containerRuntime build -t "$registryUrl/$imageName" -f Dockerfile .

# Push the container image using the generated config.json
$containerRuntime --config "$configFile" push "$registryUrl/$imageName"

# Delete the config.json file after the push
rm -f "$configFile"

echo "Build and push completed successfully."
