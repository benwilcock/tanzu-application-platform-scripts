#!/bin/bash

################################################################
# INSTALLING Tanzu Application Platform onto Kubernetes        #
################################################################

# Source the environment variables
source ./helper.sh

# Create a TAP values file from the template using the environment variables.
# prompt "Creating a tap-values.yml file using the current ENVIRONMENT variables."
# curl -o template-tap-values.yml https://raw.githubusercontent.com/benwilcock/TAPonLAP/main/TAPonLAPv1.1/template-tap-values-nix.yml
envsubst < guis-template.html > guis.html

# open in chrome
# yes_or_quit "Open in Chrome?"
# google-chrome --disable-gpu guis.html &>/dev/null

yes_or_quit "Open in Firefox?"
firefox guis.html