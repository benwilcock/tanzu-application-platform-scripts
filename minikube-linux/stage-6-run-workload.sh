#!/bin/bash

################################################################
# Deploy (Run) a Developer workload on TAP                    #
################################################################

echo -e "${BLUE}Stage 6 - Run A Developer Workload on TAP${NC}" 

# Source the environment variables
source ./helper.sh

# Run the workload?
yes_or_quit "$( echo -e "This script creates a developer workload for you. It can take a while. Continue?" )"


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

yes_or_quit "$( echo -e "Would you like to watch the workload become ready?" )"

# Watch the workload as it deploys
watch --color "tanzu apps workload get tanzu-java-web-app; echo -e '${GREEN}Wait for the Workload KNative Service to become READY and get a URL. Then press Ctrl-C and run the stage-7 script.${NC}'"