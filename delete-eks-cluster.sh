#!/usr/bin/bash

# Set up the environment variables
source tap-env.sh

# Check your env variables have been set
echo $(env | grep -E '(REGISTRY|NAMESPACE|AWS|INSTALL)')

# Delete the cluster
eksctl delete cluster --region ${AWS_REGION} --name ${AWS_CLUSTER_NAME}
