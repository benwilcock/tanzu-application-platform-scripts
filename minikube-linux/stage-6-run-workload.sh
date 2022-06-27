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
watch --color "tanzu apps workload get tanzu-java-web-app; echo -e '${GREEN}Wait for the Workload to become ${WHITE}READY${GREEN} and get a ${WHITE}URL${GREEN}. Then press Ctrl-C.${NC}'"

# # Adding the application URL entry to /etc/hosts (needs sudo)
# export ENVOY="$(minikube ip)"
# export HOSTS="tanzu-java-web-app.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN_PREFIX}.${DOMAIN}"
# message "You must now add ${GREEN}${ENVOY} ${HOSTS}${NC} to your '/etc/hosts' file."
# message "This will enable http requests to be routed to your test application."
# echo ${ENVOY} ${HOSTS} | xclip -selection c
# yes_or_no "Opening /etc/hosts in Nano (as sudo). Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano and Y to save changes. Ready?" \
#   && sudo nano /etc/hosts

prompt "Next, run the stage-7 script to test the workload."

# Checking deplyoment
# kubectl describe runnable.carto.run/tanzu-java-web-app