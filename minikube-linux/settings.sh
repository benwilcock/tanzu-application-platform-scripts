#!/bin/bash

############## Common Environment Variables #######################

# Tanzu CLI Archive file name.
export CLI_FILE="tanzu-framework-linux-amd64.tar"

# Specify the KUBERNETES version to use in Minikube
export KUBERNETES_VERSION="1.22.10"

# Specify the Minikube VM driver to use
export MINIKUBE_VM_DRIVER="kvm2" # "kvm2" or "docker" (Fedora prefers kvm2)

# Specify the amount of DISK to allocate to minikube
export MINIKUBE_DISK="150g" #Try "150g" for full "32g" for iterate

# Specify the amount of MEMORY to allocate to minikube
export MINIKUBE_MEM="32g"

# Specify the amount of CPU to allocate to minikube
export MINIKUBE_CPUS="8"

# Specify the version of TAP you wish to install
export TAP_VERSION='1.2.0-build.14' #'1.1.1' # "1.1.0"

# Specify the TAP profile (controls the tap-values.yml template choice)
export TAP_PROFILE='full' # full, iterate, etc.

# Specify the Minikube profile name
export MINIKUBE_PROFILE="${TAP_VERSION}-${TAP_PROFILE}"

# Specify how you would like the buildservice to be initialised (lite or full)
export BUILDSERVICE_TYPE='lite'

# Specify which supply chain type you would like
export SUPPLY_CHAIN_TYPE='basic'

# Specify the version of the Tanzu CLI being installed
export TANZU_CLI_VERSION="v0.11.6" # This is a folder path used by the installer.

# Specify the location of the Tanzu Network container registry containing the TAP images (usually fixed)
export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com" 

# Specify the build registry
export BUILD_REGISTRY_HOSTNAME="index.docker.io"

# Specify the location of the Docker Image Registry (e.g. DockerHub, Harbor, GCR, etc.)
export DOCKER_SERVER="https://${BUILD_REGISTRY_HOSTNAME}/v1/" # Format is different for Harbor, GCR. e.g. "harbor.made-up-name.io"

# Specify the TAP installation namespace
export TAP_INSTALL_NAMESPACE="tap-install"

# Specify the Kubernetes namespace to use as your developer workspace.
export TAP_DEV_NAMESPACE="default" 

# Specify the NodePort to use for Envoy (Ingress)
export INGRESS_PORT='31080'
export SECURED_INGRESS_PORT='31443'

# Domain to use for general ingress
export DOMAIN="nip.io" # "example.com"

# Application domain prefix
export APPS_DOMAIN_PREFIX="apps"

# Application domain prefix
export LEARNING_DOMAIN_PREFIX="learningcenter"

# Cluster Essentials for VMware Tanzu archive file name.
export TCE_FILE="tanzu-cluster-essentials-linux-amd64-1.1.0.tgz"

# This variable is needed by the Cluster Essentials for VMware Tanzu installer to identify the imgpkg bundle to use.
export INSTALL_BUNDLE="registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d"
