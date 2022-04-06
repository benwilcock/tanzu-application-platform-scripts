#!/bin/bash

################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 4 - Install the Tanzu Application Platform (TAP)." 
sub_title "This script will install TAP version ${GREEN}${TAP_VERSION}${WHITE} to Kubernetes with your images stored in ${GREEN}${REPOSITORY_TYPE}${NC}."

# Make sure you know DockerHub has its limits.
if [ "$REPOSITORY_TYPE" = "dockerhub" ]; then
    echo -e "${NC}DockerHub has limits for FREE accounts. You may struggle to install TAP or get issues later."
fi

yes_or_quit "Adding namespace, registry secrets, and repository records. Continue?"

export TAP_NAMESPACE="tap-install"

# Create the install namespace
kubectl create ns $TAP_NAMESPACE 

# Add a secret for the TAP image registry (required to install)
tanzu secret registry add tap-registry \
  --username $INSTALL_REGISTRY_USERNAME \
  --password $INSTALL_REGISTRY_PASSWORD \
  --server $INSTALL_REGISTRY_HOSTNAME \
  --namespace $TAP_NAMESPACE \
  --export-to-all-namespaces \
  --yes 

# Add a package repository record for the TAP image registry (required to install)
tanzu package repository add tanzu-tap-repository \
  --url $INSTALL_REGISTRY_HOSTNAME/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace $TAP_NAMESPACE 

# Create a TAP values file from the template using the environment variables.
prompt "Creating a tap-values.yml file using the current ENVIRONMENT variables."
curl -o tap-values.tmp https://raw.githubusercontent.com/benwilcock/tanzu-application-platform-scripts/main/minikube-linux/template-tap-values.yml 
envsubst < tap-values.tmp > tap-values.yml

yes_or_no "Print your tap-values.yml file here (contains passwords)?" && \
  cat tap-values.yml

# Install the TAP packages to Kubernetes
echo -en ${DING}
yes_or_no "Installing Tanzu Application Platform (takes 30 mins or more, needs lots of CPU, Memory and Network resources). Continue?" && \
  tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION \
    --values-file tap-values.yml \
    --poll-timeout 45m \
    --namespace $TAP_NAMESPACE

# Watch the progress of the installation
yes_or_no "Check the Reconciliation progress?" && \
  watch --color "tanzu package installed list -A; echo -e '${GREEN}When ALL packages have a STATUS of 'Reconcile Succeeded', press Ctrl-C to exit and run the stage-5 script.${NC}'"

yes_or_no "Delete the tap-values.yml file (contains passwords)?" && \
  rm tap-values.yml tap-values.tmp
