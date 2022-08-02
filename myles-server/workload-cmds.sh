#!/bin/bash

# Different ways you can push workloads to VMware Tanzu Application Platform

# Create workload from source code in a folder
tanzu apps workload create tanzu-java-web-app \
  --local-path . \ # <-- Build code from this FOLDER
  --source-image index.docker.io/wilcockb200/tanzu-java-web-app-source \
  --type web \
  --yes

# Create workload from local JAR/WAR
tanzu apps workload create tanzu-java-web-app \
  --local-path target/demo-0.0.1-SNAPSHOT.jar \ # <-- Build from this JAR (or WAR)
  --source-image index.docker.io/wilcockb200/tanzu-java-web-app-source \
  --type web \
  --yes

# Create workload from local Dockerfile
tanzu apps workload create tanzu-java-web-app \
  --local-path . \
  --source-image index.docker.io/wilcockb200/tanzu-java-web-app-source \
  --type web \
  --param dockerfile=./Dockerfile \ # <-- Build from this DOCKERFILE
  --yes

# Create workload from a remote Docker Image
tanzu apps workload create petclinic-image-to-url \
  --image docker.io/benwilcock/spring-petclinic:2.6.0-SNAPSHOT \ # <-- Run this IMAGE
  --type web \
  --yes
