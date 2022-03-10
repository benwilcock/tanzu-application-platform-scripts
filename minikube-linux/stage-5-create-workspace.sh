#!/bin/bash

################################################################
# Creating a Developer workspace on Kubernetes & TAP           #
################################################################

echo -e "${BLUE}Stage 5 - Create a Developer Workspace${NC}" 

# Source the environment variables
source ./helper.sh

yes_or_quit "$( echo -e "${NC}This script will create a developer workspace on TAP and add registry-credentials for $REPOSITORY_TYPE. Continue?" )"

# Create a namespace for the developer to work in 
kubectl create ns ${TAP_DEV_NAMESPACE} 

# Add the secret for the BUILD Container Registry 
tanzu secret registry add registry-credentials --server ${DOCKER_SERVER} --username ${DOCKER_USERNAME} --password ${DOCKER_PASSWORD} --namespace ${TAP_DEV_NAMESPACE} 


# Obtain the service accounts file 
curl -o serviceaccounts.yml https://raw.githubusercontent.com/benwilcock/tanzu-application-platform-scripts/main/minikube-win/serviceaccounts.yml 

# Add the necessary RBAC Roles, Accounts, Bindings etc... 
kubectl -n ${TAP_DEV_NAMESPACE} apply -f "serviceaccounts.yml" 

echo -e "${GREEN}Next, run the stage-6 script.${NC}" 5