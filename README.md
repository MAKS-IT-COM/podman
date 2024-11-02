# Podman Container Project

## Overview

This repository contains the configuration and scripts for building a container image designed to perform Docker image building tasks using either Docker or Podman, similar to tools like Kaniko. The primary goal of this project is to provide a secure and efficient environment for building Docker images, with configurations tailored to support rootless containerization and flexibility in choosing the container runtime.

## Features

- **Rootless Containerization**: The container is configured to run as a non-root user, enhancing security.
- **Container Runtime Flexibility**: Supports both Docker and Podman as the container runtime. Docker is the default, but you can easily switch to Podman using a flag.
- **Customizable Image Name**: Set the image name directly in the script to match your needs.
- **Customizable Storage Configuration**: Configured with `fuse-overlayfs` for storage management, suitable for rootless environments.
- **Automated Build and Push**: Scripts provided to automate the build and push process of Docker images to a specified container registry.

## Repository Structure

- **build.bat**: Batch script for initiating the build process on Windows environments. It triggers the PowerShell script `build.ps1`.
- **build.ps1**: PowerShell script that supports selecting between Docker and Podman as the container runtime, creates a `config.json` file for authentication, builds the container image, and pushes it to the specified container registry.
- **build.sh**: Bash script that supports selecting between Docker and Podman as the container runtime, creates a `config.json` file for authentication, builds the container image, and pushes it to the specified container registry.
- **Dockerfile**: Dockerfile for creating the container image. The container is configured with a non-root user and necessary storage settings.
- **storage.conf**: Configuration file for storage settings, utilizing the `fuse-overlayfs` driver for rootless operation.

## Prerequisites

- **Podman/Docker**: Ensure that either Podman or Docker is installed on your system.
- **Environment Variables**: The `CR_MAKS_IT` environment variable is used in the examples for pushing images to the registry. 

### Generating and Setting the `CR_MAKS_IT` Environment Variable

Create a base64-encoded string of your `username:password` and set it as a permanent environment variable on your system. Here’s how:

#### Linux/Unix

1. **Create the Base64-Encoded Credentials**:
   - Open a terminal and run the following command to encode your `username:password` in base64:
     ```bash
     echo -n 'username:password' | base64
     ```
   - This will output a base64-encoded string, for example:
     ```
     dXNlcm5hbWU6cGFzc3dvcmQ=
     ```

2. **Set the Encoded String as a Permanent Environment Variable**:
   - Open your shell profile in a text editor (e.g., `~/.bashrc`, `~/.zshrc`, etc.):
     ```bash
     nano ~/.bashrc  # Or ~/.zshrc for Zsh users
     ```
   - Add the following line to set the `CR_MAKS_IT` environment variable permanently:
     ```bash
     export CR_MAKS_IT="dXNlcm5hbWU6cGFzc3dvcmQ="
     ```
   - Save the file and reload your shell profile to apply the changes:
     ```bash
     source ~/.bashrc  # Or source ~/.zshrc
     ```

3. **Verify the Environment Variable**:
   - Run the following command to verify that the `CR_MAKS_IT` variable is set:
     ```bash
     echo $CR_MAKS_IT
     ```

#### Windows

1. **Create the Base64-Encoded Credentials**:
   - Open a PowerShell prompt and run the following command to encode your `username:password` in base64:
     ```powershell
     [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("username:password"))
     ```
   - This will output a base64-encoded string, for example:
     ```
     dXNlcm5hbWU6cGFzc3dvcmQ=
     ```

2. **Set the Encoded String as a Permanent Environment Variable**:
   - To set the environment variable permanently, add the following line to your PowerShell profile (`$PROFILE`):
     ```powershell
     [System.Environment]::SetEnvironmentVariable("CR_MAKS_IT", "dXNlcm5hbWU6cGFzc3dvcmQ=", "User")
     ```
   - Alternatively, you can set it via the Windows GUI:
     - Open the Start Menu and search for "Environment Variables".
     - Click on "Edit the system environment variables".
     - In the System Properties window, click "Environment Variables".
     - Under "User variables", click "New" and add:
       - **Variable name**: `CR_MAKS_IT`
       - **Variable value**: `dXNlcm5hbWU6cGFzc3dvcmQ=`
     - Click OK to save the changes.

3. **Verify the Environment Variable**:
   - Run the following command in PowerShell to verify that the `CR_MAKS_IT` variable is set:
     ```powershell
     echo $env:CR_MAKS_IT
     ```

## Configuration

Before using the build scripts, you may need to update the registry URL and image name according to your setup:

1. **Update the Registry URL and Image Name**:
   - Open the `build.ps1` or `build.sh` script in a text editor.
   - Update the `registryUrl` variable to match your Docker or Podman registry:
     ```powershell
     $registryUrl = "your-registry-url.com"
     ```
     ```bash
     registryUrl="your-registry-url.com"
     ```
   - Set the image name directly in the script:
     ```powershell
     $ImageName = "your-image-name:latest"
     ```
     ```bash
     imageName="your-image-name:latest"
     ```

## Usage

### Windows

1. Clone the repository:
   ```bash
   git clone https://your-repository-url/podman.git
   cd podman
   ```

2. Ensure the `CR_MAKS_IT` environment variable is set with your registry authentication token.

3. Run the build script with Docker (default):
   ```cmd
   build.bat
   ```

### Unix/Linux

1. Clone the repository:
   ```bash
   git clone https://your-repository-url/podman.git
   cd podman
   ```

2. Ensure the `CR_MAKS_IT` environment variable is set with your registry authentication token.

3. Run the build script with Docker (default):
   ```bash
   ./build.sh
   ```

4. Run the build script with Podman:
   ```bash
   ./build.sh --container-runtime podman
   ```

## Contributing

Contributions are welcome! Please submit issues or pull requests to help improve this project.

## Contact

If you have any questions or need further assistance, feel free to reach out:

- **Email**: [maksym.sadovnychyy@gmail.com](mailto:maksym.sadovnychyy@gmail.com)
- **Reddit**: [Running Podman Inside a Podman Container: A Technical Deep Dive for CI/CD and Kubernetes Microservices](https://www.reddit.com/r/MaksIT/comments/1euiznn/running_podman_inside_a_podman_container_a/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)

### Additional Note: Setting Up Podman API on RHEL-Based Distributions (e.g., Fedora)

If you need to set up the Podman API service to allow remote management of containers, follow these steps:

1. **Modify the Podman Service File**:
   - Open the Podman systemd service file for editing:
     ```bash
     sudo nano /usr/lib/systemd/system/podman.service
     ```
   - Locate the line starting with `ExecStart` and modify it to enable the Podman API over TCP. Change the line to:
     ```bash
     ExecStart=/usr/bin/podman $LOGGING system service --time=0 tcp:0.0.0.0:<Your Port>
     ```
   - This configuration sets up the Podman service to listen on all network interfaces on port `<Your Port>`.

2. **Reload Systemd Daemon**:
   - After making changes to the service file, reload the systemd daemon to apply the modifications:
     ```bash
     sudo systemctl daemon-reload
     ```

3. **Restart the Podman Service**:
   - Restart the Podman service to activate the changes:
     ```bash
     sudo systemctl restart podman.service
     ```

4. **Test the Remote Podman API**:
   - You can verify that the Podman API is running and accessible remotely by using `curl`:
     ```bash
     curl http://<Your IP>:<Your Port>/v1.40/libpod/info
     ```
   - Replace `<Your IP>` with the actual IP address of your machine. This command should return information about the Podman service, confirming that the API is accessible.

>**Note** Exposing the Podman API over TCP without proper security (e.g., TLS, authentication) can pose security risks. Make sure to implement appropriate security measures in production environments.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.md) file for details.
