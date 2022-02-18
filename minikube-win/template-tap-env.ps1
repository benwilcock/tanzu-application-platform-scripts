# Tanzu Cluster Essentials & TAP Environment Variables
$Env:TAP_VERSION = "1.0.1"

# Installation registry - contains TAP images
$Env:INSTALL_BUNDLE = "registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343"
$Env:INSTALL_REGISTRY_HOSTNAME = "registry.tanzu.vmware.com"
$Env:INSTALL_REGISTRY_USERNAME = "" # "tanzu-username"
$Env:INSTALL_REGISTRY_PASSWORD = "" # "tanzupassword"

# Tanzu CLI Installation Environment Variables
$Env:TANZU_CLI_NO_INIT = "true"

# TAP Installation Environment Variables
# Code and supply chain registry
$Env:REGISTRY_SERVER = "" # "harbor.made-up-name.io" DockerHub ??
$Env:REGISTRY_USERNAME = "" # "your-username"
$Env:REGISTRY_PASSWORD = "" # "your-password"
$Env:TAP_NAMESPACE = "tap-install"
$Env:TAP_DEV_NAMESPACE = "default"
$Env:TAP_INSTALL_DIR = "."

# Print all variables to the screen
dir env:
