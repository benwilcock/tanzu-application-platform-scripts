#!/bin/bash

############## Common Environment Variables #######################

# Specify the Minikube VM driver to use
export MINIKUBE_VM_DRIVER="docker" # "kvm2" or "docker" (Fedora prefers kvm2)

# Specify the version of TAP you wish to install
export TAP_VERSION="1.0.2" # "1.0.1" "1.0.0"

# Specify the type of Docker repository service where your images will go...
export REPOSITORY_TYPE="dockerhub" # One of "dockerhub" or "harbor"

# Specify the location of the Tanzu Network container registry containing the TAP images (usually fixed)
export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com" 

# Specify the location of the Docker Image Registry (e.g. DockerHub, Harbor, GCR, etc.)
export DOCKER_SERVER="https://index.docker.io/v1/" # Format is different for Harbor, GCR. e.g. "harbor.ryanbaker.io"

# Specify the Kubernetes namespace to use as your developer workspace.
export TAP_DEV_NAMESPACE="default" 

# Bringing in additional ENV properties
source ./secret-${REPOSITORY_TYPE}-tap-env.sh # will resolve to 'secret-dockerhub-tap-env.sh' if REPOSITORY_TYPE="dockerhub"