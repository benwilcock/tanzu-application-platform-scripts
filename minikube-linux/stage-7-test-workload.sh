#!/bin/bash

################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
# See 'stage-01.ps1' for details.                              #
################################################################

echo -e "${BLUE}Stage 7 - Test the running Workload on TAP${NC}" 

# Source the environment variables
source ./helper.sh

yes_or_quit "$( echo -e "This script uses curl to make a request to your workload on TAP. Continue?" )"

# Test the application is responding (may take a few seconds at first)
echo -e "${GREEN}Curling: ${NC}Look out for the words ${WHITE}'Greetings from Spring Boot + Tanzu!'${NC}." 
curl http://tanzu-java-web-app.default.apps.made-up-name.net 

# Test the application is responding (may take a few seconds at first)
echo -e "${GREEN}Curling: ${NC}Checking ${WHITE}'/actuator/health'${NC}." 
curl http://tanzu-java-web-app.default.apps.made-up-name.net/actuator/health

echo -e "${GREEN}Congratulations!${NC}Your work here is done!." 
