#!/bin/bash

##################################################################
# These functions and variables are used by the install scripts. #
# Make sure they're correct before you begin!                    #
##################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Moving on..." ; return 1 ;;
        esac
    done
}

function yes_or_quit {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Exiting" ; exit ;;
        esac
    done
}

function check_file {
    FILE=$1
    if [ -f $FILE ]; then
        return 0;
    else 
        echo -e "${RED}File '${FILE}' is missing! Create one using the template supplied.${NC}"
        exit
    fi
}

############## Common Environment Variables #######################

# Specify the version of TAP you wish to install
export TAP_VERSION="1.0.2" # "1.1.0-build.5" # "1.0.1" "1.0.2-build.8"

# Specify the type of Docker repository service where your images will go...
export REPOSITORY_TYPE="dockerhub" # One of "dockerhub" "harbor"

# Specify the location of the Tanzu Network container registry containing the TAP images (usually fixed)
export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com" 

# Specify the location of the Docker Image Registry (e.g. DockerHub, Harbor, GCR, etc.)
export DOCKER_SERVER="https://index.docker.io/v1/" # Format is different for Harbor, GCR, etc!

# Specify the Kubernetes namespace to use as your developer workspace.
export TAP_DEV_NAMESPACE="default" 


############## Pre Flight Checks... ##############################

# Make sure you add you credentials to  the file:
check_file "secret-${REPOSITORY_TYPE}-tap-env.sh"
check_file "secret-${REPOSITORY_TYPE}-tap-values.yml"

# Make sure you know DockerHub has its limits.
if [ "$REPOSITORY_TYPE" = "dockerhub" ]
  then
    echo -e "${NC}DockerHub has limits for FREE accounts. You may struggle to install TAP or get issues later."
fi