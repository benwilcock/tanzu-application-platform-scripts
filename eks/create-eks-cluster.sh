#!/usr/bin/bash

# Set up the environment variables
source ../tap-env.sh

# Check your env variables have been set
echo $(env | grep -E '(REGISTRY|NAMESPACE|AWS|INSTALL)')

# Create a cluster on EKS
eksctl create cluster \
--name ${AWS_CLUSTER_NAME} \
--version 1.21 \
--region ${AWS_REGION} \
--nodegroup-name worker-nodes \
--node-type m5.xlarge \
--nodes 5