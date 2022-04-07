#!/bin/bash

################################################################
# Creating a Developer workspace on Kubernetes & TAP           #
################################################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 5 - Create a Developer Workspace" 

# Create the workspace?
message "This script will create a developer workspace on TAP and add registry-credentials for $REPOSITORY_TYPE."

yes_or_quit "Continue?"

# Create a namespace for the developer to work in 
kubectl create ns ${TAP_DEV_NAMESPACE} 

# Add the secret for the BUILD Container Registry 
tanzu secret registry add registry-credentials \
  --server ${DOCKER_SERVER} \
  --username ${DOCKER_USERNAME} \
  --password ${DOCKER_PASSWORD} \
  --namespace ${TAP_DEV_NAMESPACE} 

# Obtain the service accounts file 
curl -o serviceaccounts.yml https://raw.githubusercontent.com/benwilcock/TAPonLAP/main/TAPonLAPv1.1/serviceaccounts.yml

# Add the necessary RBAC Roles, Accounts, Bindings etc... 
kubectl -n ${TAP_DEV_NAMESPACE} apply -f "serviceaccounts.yml" 

prompt "Next, run the stage-6 script."
