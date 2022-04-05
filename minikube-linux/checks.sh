#!/bin/bash

############## Pre Flight Checks... ##############################

# Check the settings
[ -z "$MINIKUBE_VM_DRIVER" ] && { echo "MINIKUBE_VM_DRIVER env var must not be empty"; exit 1; }
[ -z "$TAP_VERSION" ] && { echo "TAP_VERSION env var must not be empty"; exit 1; }
[ -z "$TANZU_CLI_VERSION" ] && { echo "TANZU_CLI_VERSION env var must not be empty"; exit 1; }
[ -z "$REPOSITORY_TYPE" ] && { echo "REPOSITORY_TYPE env var must not be empty"; exit 1; }
[ -z "$TAP_DEV_NAMESPACE" ] && { echo "TAP_DEV_NAMESPACE env var must not be empty"; exit 1; }
[ -z "$DOMAIN" ] && { echo "DOMAIN env var must not be empty"; exit 1; }
[ -z "$APPS_DOMAIN" ] && { echo "APPS_DOMAIN env var must not be empty"; exit 1; }
[ -z "$TCE_FILE" ] && { echo "TCE_FILE env var must not be empty"; exit 1; }
[ -z "$CLI_FILE" ] && { echo "CLI_FILE env var must not be empty"; exit 1; }

#Check the Tanzu Registry details are set
[ -z "$INSTALL_BUNDLE" ] && { echo "INSTALL_BUNDLE env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_HOSTNAME" ] && { echo "INSTALL_REGISTRY_HOSTNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "INSTALL_REGISTRY_USERNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "INSTALL_REGISTRY_PASSWORD env var must not be empty"; exit 1; }

#Check the Docker Registry details are set
[ -z "$DOCKER_SERVER" ] && { echo "DOCKER_SERVER env var must not be empty"; exit 1; }
[ -z "$DOCKER_USERNAME" ] && { echo "DOCKER_USERNAME env var must not be empty"; exit 1; }
[ -z "$DOCKER_PASSWORD" ] && { echo "DOCKER_PASSWORD env var must not be empty"; exit 1; }