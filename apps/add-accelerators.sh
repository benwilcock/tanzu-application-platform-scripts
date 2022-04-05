#!/bin/bash

source ../minikube-linux/helper.sh

# Add Spring Boot Admin (SBA) Accelerator
tanzu accelerator create spring-boot-admin \
--git-repository https://github.com/benwilcock/spring-boot-admin \
--git-branch main \
--icon-url https://github.com/benwilcock/spring-boot-admin/raw/main/images/logo-spring-boot-admin.png 

kubectl apply -f sba-k8s-resource.yaml --namespace accelerator-system

tanzu accelerator update spring-boot-admin --reconcile