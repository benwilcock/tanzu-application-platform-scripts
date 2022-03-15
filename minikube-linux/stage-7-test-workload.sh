#!/bin/bash

################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
# See 'stage-01.ps1' for details.                              #
################################################################

# Source the environment variables
source ./helper.sh

# Dexcribe the stage
title "Stage 7 - Test the running Workload on TAP." 
sub_title "This script makes a HTTP request to the workload running on TAP (requires curl)."

# Test the workload?
yes_or_quit "Call the workload?"

# Test the application is responding (may take a few seconds at first)
message "Calling the workload.\n" 
RESPONSE="$(curl --silent http://tanzu-java-web-app.default.apps.made-up-name.net)"
message "Workload response: '${RESPONSE}'" 

if [ "${RESPONSE}" = "Greetings from Spring Boot + Tanzu!" ]; then
    message "\n${GREEN}Congratulations! Your work here is done!.${NC}";
else
    message "\n${RED}Oops! Your work here is not done! ${WHITE}:(${NC}";
fi 
