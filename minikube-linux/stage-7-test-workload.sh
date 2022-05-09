#!/bin/bash

################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
################################################################

# Source the environment variables
source ./helper.sh

# Dexcribe the stage
title "Stage 7 - Test the running Workload on TAP." 
sub_title "This script makes a HTTP request to the workload running on TAP (requires curl)."

# Test the workload?
yes_or_quit "Test the workload?"

# Get the Minikube IP
export MINIKUBE_IP="$(minikube ip)"

# Test the application is responding (may take a few seconds at first)
message "Testing the workload by sending a request.\n" 
RESPONSE="$(curl --silent http://tanzu-java-web-app.$TAP_DEV_NAMESPACE.apps.$MINIKUBE_IP.$DOMAIN)"
message "Workload response: '${RESPONSE}'" 

if [ "${RESPONSE}" = "Greetings from Spring Boot + Tanzu!" ]; then
    message "\n${GREEN}Congratulations! Your work here is done!.${NC}";
else
    message "\n${RED}Oops! Your work here is not done! ${WHITE}:(${NC}";
fi 
