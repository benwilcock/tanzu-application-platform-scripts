# Set the environment variables
. .\tap-env.ps1

# TAP Works with Kubernetes  1.20, 1.21, or 1.22
minikube start --cpus=8 --memory=16g --kubernetes-version='1.22.6'

# Download Tanzu CLI for Windows
# https://network.tanzu.vmware.com/products/tanzu-application-platform/#/releases/1043418/file_groups/6962
# Download tanzu-framework-windows-amd64.zip & extract the archive.
# Locate and copy the core/v0.11.1/tanzu-core-windows_amd64.exe into the new Program Files\tanzu folder.
# Copy "Downloads\tanzu-framework-windows-amd64\cli\core\v0.11.1\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe"
# Rename "C:\Program Files\tanzu\tanzu-core-windows_amd64.exe" to "C:\Program Files\tanzu\tanzu.exe"

# Check the version
tanzu version
# version: v0.11.1
# buildDate: 2022-02-14
# sha: 4d578570

