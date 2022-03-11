#!/bin/bash

################################################################
# Deploy (Run) a Developer workload on TAP                    #
################################################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 6 - Run A Developer Workload on TAP." 

# Run the workload?
sub_title "This script creates a developer workload for you. This can take a while the first time you do it."

yes_or_quit "Continue?"

# Schedule a workload to run - this may take several minutes
tanzu apps workload create tanzu-java-web-app \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --label tanzu.app.live.view=true \
  --label tanzu.app.live.view.application.name=tanzu-java-web-app \
  --namespace $TAP_DEV_NAMESPACE \
  --yes 

# Watch the workload as it deploys
yes_or_quit "Would you like to watch the workload become ready?"
watch --color "tanzu apps workload get tanzu-java-web-app; echo -e '${GREEN}Wait for the Workload to become ${WHITE}READY${GREEN} and get a ${WHITE}URL${GREEN}. Then press Ctrl-C and run the stage-7 script.${NC}'"
