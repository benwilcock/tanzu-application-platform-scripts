# Source common functions & variables
source ./helper.sh

# Describe this stage
title "Stage 1 - Installing the Tanzu CLI" 
sub_title "This script installs the Tanzu CLI and the plugins required ti install TAP."
message "If you already have the correct Tanzu CLI and plugins installed you can skip this step."

yes_or_no "Continue?"
yes_or_quit "Continue?"