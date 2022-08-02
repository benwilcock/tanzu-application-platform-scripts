#!/bin/bash

source ./helper.sh

# yes_or_no "Switch Kubectl's context to tap-build?" && \
#  kubectx tap-build

WORK_DIR=(pwd)

cd $HOME/Code/Scratches/tanzu-java-web-app
pwd

yes_or_no "Deploy Tanzu Java Web App from local source?" && \
tanzu apps workload create tanzu-java-web-app-bw \
  --local-path . \
  --label app.kubernetes.io/part-of=tanzu-java-web-app-bw \
  --label apps.tanzu.vmware.com/has-tests=true \
  --source-image index.docker.io/wilcockb200/tanzu-java-web-app-bw-source \
  --namespace $TAP_DEV_NAMESPACE \
  --type web

yes_or_no "Tail the workload logs?" && \
  tanzu apps workload tail tanzu-java-web-app-bw -n $TAP_DEV_NAMESPACE

yes_or_no "Watch the workload status?" && \
  watch tanzu apps workload get tanzu-java-web-app-bw -n $TAP_DEV_NAMESPACE

cd $WORK_DIR

# yes_or_no "Open the TAP GUI in Google Chrome?" && \
#  nohup google-chrome --disable-gpu http://tap-gui.tap-mc.labs.satm.eng.vmware.com/  &>/dev/null
