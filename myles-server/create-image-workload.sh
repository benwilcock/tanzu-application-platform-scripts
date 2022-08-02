#!/bin/bash

source ./helper.sh

yes_or_no "Switch Kubectl's context to tap-build?" && \
 kubectx tap-build

yes_or_no "Deploy the Spring Pet Clinic using a DockerHub Image?" && \
  tanzu apps workload create petclinic-image-to-url \
    --image docker.io/benwilcock/spring-petclinic:2.6.0-SNAPSHOT \
    --type web \
    --label app.kubernetes.io/part-of=petclinic-image-to-url \
    --annotation autoscaling.knative.dev/minScale=1 \
    --namespace $TAP_DEV_NAMESPACE \
    --yes

yes_or_no "Tail the workload logs?" && \
  tanzu apps workload tail petclinic-image-to-url

yes_or_no "Watch the workload status?" && \
  watch tanzu apps workload get petclinic-image-to-url

# yes_or_no "Open the TAP GUI in Google Chrome?" && \
#  nohup google-chrome --disable-gpu http://tap-gui.tap-mc.labs.satm.eng.vmware.com/  &>/dev/null
