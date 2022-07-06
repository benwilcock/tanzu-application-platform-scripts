#!/bin/bash

################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
################################################################

# Source the environment variables
source ./helper.sh

# Dexcribe the stage
title "Create a TAP Menu HTML Page." 
sub_title "This script makes a HTML page containing links to TAP GUI's."

# Create a convenient GUIs file
yes_or_no "Create the tap-guis.html file?" && \
  envsubst < tap-guis-template.html > tap-guis.html

# Open GUIs in chrome
yes_or_no "Open the tap-guis.html file in Google Chrome?" && \
  nohup google-chrome --disable-gpu tap-guis.html &>/dev/null