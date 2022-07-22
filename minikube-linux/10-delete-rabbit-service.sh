#!/bin/bash

################################################################
# Delete the RabbitMQ Service Capability  #
#   #
################################################################

# Source the environment variables
source ./helper.sh
export RMQ_INSTANCE="rmq-2"
export SERVICE_INSTANCES_NAMESPACE="service-instances"

# Delete workloads
tanzu apps workload delete spring-sensors-consumer-web --yes
tanzu apps workload delete spring-sensors-producer --yes

# Show the list of claims
tanzu service claim list

# Delete the Tanzu Service Claim
tanzu service claim delete $RMQ_INSTANCE --yes

kubectl delete -f rabbit-claim-policy.yaml
kubectl delete -f rabbit-service-instance.yaml

# Delete the namespace
kubectl delete namespace $SERVICE_INSTANCES_NAMESPACE

kubectl delete -f rabbit-cluster-clusterinstanceclass.yaml
kubectl delete -f rabbit-resource-claims-rmq.yaml

# Delete the RabbitMQ Operator
kapp -y delete --app rmq-operator

# Delete the service toolkit (TAP will recover)
tanzu package installed delete services-toolkit --namespace tap-install -y
tanzu package installed delete service-bindings --namespace tap-install -y