#!/bin/bash

source ../tap-env.sh

# Add new creds to the docker config and login
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 837334766153.dkr.ecr.us-east-2.amazonaws.com

# Extract those creds in plain text from the docker credentials file
cat ~/.docker/config.json | jq -r '.[]."837334766153.dkr.ecr.us-east-2.amazonaws.com".auth' | base64 --decode