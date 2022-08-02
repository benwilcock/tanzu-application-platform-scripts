#!/bin/bash

source ./helper.sh

export RMQ_INSTANCE="rmq-1"
export SERVICE_INSTANCES_NAMESPACE="service-instances"

# Claim a Service Instance
message "Checking the list of Claimable Services."
tanzu service claimable list --class rabbitmq

message "Claiming the RabbitMQ Service Instance: ${RMQ_INSTANCE}"
tanzu service claim create $RMQ_INSTANCE \
  --resource-name $RMQ_INSTANCE \
  --resource-namespace $SERVICE_INSTANCES_NAMESPACE \
  --resource-kind RabbitmqCluster \
  --resource-api-version rabbitmq.com/v1beta1

message "Look for the new Service Claim in the list below..."
tanzu services claims get $RMQ_INSTANCE --namespace default

# Run Spring Sensors
yes_or_no "Run Spring Sensors UI?" \
    && tanzu apps workload apply spring-sensors \
        --git-repo https://gitlab.com/tanzuplatform/samples/spring-sensors.git \
        --git-branch santa \
        --type web \
        --label app.kubernetes.io/part-of=spring-sensors \
        --label apps.tanzu.vmware.com/has-tests=true \
        --label tanzu.app.live.view=true \
        --label tanzu.app.live.view.application.name=spring-sensors \
        --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:$RMQ_INSTANCE" \
        --annotation autoscaling.knative.dev/minScale=1 \
        --param gitops_ssh_secret= \
        --namespace $TAP_DEV_NAMESPACE \
        --yes 

yes_or_no "Run the Spring Sensors (Producer) Workload?" \
    && tanzu apps workload apply spring-sensors-sensor \
        --git-repo https://gitlab.com/tanzuplatform/samples/spring-sensors-sensor.git \
        --git-branch main \
        --type web \
        --label app.kubernetes.io/part-of=spring-sensors-sensor \
        --label apps.tanzu.vmware.com/has-tests=true \
        --label tanzu.app.live.view=true \
        --label tanzu.app.live.view.application.name=spring-sensors-sensor \
        --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:$RMQ_INSTANCE" \
        --annotation autoscaling.knative.dev/minScale=1 \
        --param gitops_ssh_secret= \
        --namespace $TAP_DEV_NAMESPACE \
        --yes
