#!/bin/bash

############## Common Environment Variables #######################

# Specify the Minikube VM driver to use
export MINIKUBE_VM_DRIVER="kvm2" # "kvm2" or "docker" (Fedora prefers kvm2)

# Specify the version of TAP you wish to install
export TAP_VERSION='1.1.0-build.17' # "1.0.2" # "1.0.1" "1.0.0"

# Specify the version of the Tanzu CLI being installed
export TANZU_CLI_VERSION="v0.11.2" # This is a folder path used by the installer.

# Specify the type of Docker repository service where your images will go...
export REPOSITORY_TYPE="dockerhub" # One of "dockerhub" or "harbor"

# Specify the location of the Tanzu Network container registry containing the TAP images (usually fixed)
export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com" 

# Specify the location of the Docker Image Registry (e.g. DockerHub, Harbor, GCR, etc.)
export DOCKER_SERVER="https://index.docker.io/v1/" # Format is different for Harbor, GCR. e.g. "harbor.made-up-name.io"

# Specify the Kubernetes namespace to use as your developer workspace.
export TAP_DEV_NAMESPACE="default" 

# Domain for system generally
export DOMAIN="example.com"

# Specify the domain that apps get deployed into
export APPS_DOMAIN="apps.${DOMAIN}"

# Cluster Essentials for VMware Tanzu archive file name.
export TCE_FILE="tanzu-cluster-essentials-linux-amd64-1.1.0.tgz"

# This variable is needed by the Cluster Essentials for VMware Tanzu installer to identify the imgpkg bundle to use.
export INSTALL_BUNDLE="registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d"

# Tanzu CLI Archive file name.
export CLI_FILE="tanzu-framework-linux-amd64.tar"

# Make sure the credentials files exist:
check_file "secret-${REPOSITORY_TYPE}-tap-env.sh"

# Bringing in additional ENV properties
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/secret-${REPOSITORY_TYPE}-tap-env.sh"
