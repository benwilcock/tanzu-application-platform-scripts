#!/bin/bash

################################################################
#   #
#   #
################################################################

# Source the environment variables
source ./helper.sh
export RMQ_INSTANCE="rmq-2"
export SERVICE_INSTANCES_NAMESPACE="service-instances"

# Dexcribe the stage
title "Create a RabbitMQ Service" 
sub_title "This script makes a RabbitMQ service available to developers"

# Create a Service
message "Creating the RabbitMQ Service Operator"
kapp -y deploy --app rmq-operator --file rabbit-cluster-operator.yml
kubectl apply -f rabbit-resource-claims-rmq.yaml
kubectl apply -f rabbit-cluster-clusterinstanceclass.yaml

# Create the service instance namespace
message "Creating the Service Instance Namespace: ${SERVICE_INSTANCES_NAMESPACE}"
kubectl create namespace $SERVICE_INSTANCES_NAMESPACE

# Create a new service instance
message "Creating a new Service Instance"
envsubst < rabbit-service-instance-template.yaml > rabbit-service-instance.yaml
kubectl apply -f rabbit-service-instance.yaml
kubectl apply -f rabbit-claim-policy.yaml

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

yes_or_no "Run the Spring Sensors (Consumer) Workload?" \
    && tanzu apps workload create spring-sensors-consumer-web \
  --git-repo https://github.com/sample-accelerators/spring-sensors-rabbit \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=spring-sensors-rabbit \
  --annotation autoscaling.knative.dev/minScale=1 \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:$RMQ_INSTANCE" \
  --yes 

yes_or_no "Run the Spring Sensors (Producer) Workload?" \
    && tanzu apps workload create spring-sensors-producer \
  --git-repo https://github.com/tanzu-end-to-end/spring-sensors-sensor \
  --git-branch main \
  --type web \
  --label app.kubernetes.io/part-of=spring-sensors-rabbit \
  --annotation autoscaling.knative.dev/minScale=1 \
  --service-ref="rmq=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:$RMQ_INSTANCE" \
  --yes

  # Scaling Spring Sensors (publisher)
yes_or_no "Scale up the Spring Sensors Publisher to 3?" \
    && tanzu apps workload update spring-sensors-producer --annotation autoscaling.knative.dev/minScale=3

# Troubleshooting
# kubectl get secret -o json rmq-2-default-user | jq
