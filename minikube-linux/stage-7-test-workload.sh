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

# Test the application is responding (may take a few seconds at first)
message "Testing the workload by sending a request.\n" 
RESPONSE="$(curl --silent http://tanzu-java-web-app.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN_PREFIX}.${MINIKUBE_IP}.${DOMAIN})"
message "Workload response: '${RESPONSE}'" 

if [ "${RESPONSE}" = "Greetings from Spring Boot + Tanzu!" ]; then
    message "\n${GREEN}Congratulations! Your work here is done!.${NC}";
else
    message "\n${RED}Oops! Your work here is not done! ${WHITE}:(${NC}";
fi 

# Create a convenient GUIs file
yes_or_no "Would you like a tap-guis.html file for this installation?" && \
  envsubst < tap-guis-template.html > tap-guis.html

# Open GUIs in chrome
yes_or_no "Open the tap-guis.html file in Google Chrome?" && \
  nohup google-chrome --disable-gpu tap-guis.html &>/dev/null
