#!/bin/bash

################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 4 - Install the Tanzu Application Platform (TAP)." 
sub_title "This script will install TAP version ${GREEN}${TAP_VERSION}${WHITE} to Kubernetes with your images stored in ${GREEN}${BUILD_REGISTRY_HOSTNAME}${NC}."

# Make sure you know DockerHub has its limits.
if [ "$BUILD_REGISTRY_HOSTNAME" = "index.docker.io" ]; then
    echo -e "${NC}DockerHub has limits for FREE accounts. You may struggle to install TAP or get issues later."
fi

# Download a template for tap-values.
curl -v -o template-tap-values.yml https://raw.githubusercontent.com/benwilcock/TAPonLAP/main/TAPonLAPv1.2/template-tap-values-nix-${TAP_PROFILE}.yml

# Substitute the current environment variables into the template to create a tap-values.yml file
prompt "Creating a tap-values.yml file using the current ENVIRONMENT variables."
envsubst < template-tap-values.yml > tap-values.yml

# Check your values before proceeding
yes_or_no "Would you like to view your tap-values.yml file (contains passwords)?" && \
  bat tap-values.yml

yes_or_quit "Prepare the Tanzu Application Platform installation namespace, registry secrets, and repository records?"

# Create the install namespace
kubectl create ns $TAP_INSTALL_NAMESPACE 

# Add a secret for the TAP image registry (required to install)
tanzu secret registry add tap-registry \
  --username $INSTALL_REGISTRY_USERNAME \
  --password $INSTALL_REGISTRY_PASSWORD \
  --server $INSTALL_REGISTRY_HOSTNAME \
  --namespace $TAP_INSTALL_NAMESPACE \
  --export-to-all-namespaces \
  --yes 

# Add a package repository record for the TAP image registry (required to install)
tanzu package repository add tanzu-tap-repository \
  --url $INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace $TAP_INSTALL_NAMESPACE 

# Install the TAP packages to Kubernetes
yes_or_quit "Install Tanzu Application Platform (takes 30 mins or more, needs lots of CPU, Memory and Network resources)?"

# Install Tanzu Application Platform
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION \
  --values-file tap-values.yml \
  --poll-timeout 60m \
  --namespace $TAP_INSTALL_NAMESPACE

# Watch the result of the installation
yes_or_no "Watch the Tanzu Application Platform reconciliation status?" && \
  watch --color "tanzu package installed list -A; echo -e '${GREEN}When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C to exit and run the stage-5 script.${NC}'"

# Remove the TAP values files?
yes_or_no "Delete the tap-values files (contain passwords & settings)?" && \
  rm tap-values.yml template-tap-values.yml

# Finished
prompt "You can now run the stage-5 script."