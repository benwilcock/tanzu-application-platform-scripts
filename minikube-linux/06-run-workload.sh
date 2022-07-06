#!/bin/bash

################################################################
# Deploy (Run) a Developer workload on TAP                    #
################################################################

# Source the environment variables
source ./helper.sh

# Describe the stage
title "Stage 6 - Run A Workload on TAP." 

# Run the workload?
sub_title "This script deploys a test workload. This can take several minutes."

yes_or_quit "Continue?"

# Schedule a workload to run - this may take a while
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
watch --color "tanzu apps workload get tanzu-java-web-app; echo -e '${GREEN}Wait for KNative Services to report a ${WHITE}Ready${GREEN} state and provide a ${WHITE}URL${GREEN}. Then press Ctrl-C.${NC}'"

# Checking deplyoment
kubectl describe runnable.carto.run/tanzu-java-web-app

