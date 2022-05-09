#!/bin/bash

source ./helper.sh

export JVM_OPTS="-Dmanagement.server.port=8080"
export APPS_DOMAIN="$APPS_DOMAIN_PREFIX.$MINIKUBE_IP.$DOMAIN"

##################################
# Add some Workloads to TAP
##################################

# Spring Boot Admin
yes_or_no "Run Spring Boot Admin?" \
    && tanzu apps workload create spring-boot-admin \
        --git-repo https://github.com/benwilcock/spring-boot-admin \
        --git-branch main \
        --type web \
        --label app.kubernetes.io/part-of=spring-boot-admin \
        --label tanzu.app.live.view=false \
        --label tanzu.app.live.view.application.name=spring-boot-admin \
        --annotation autoscaling.knative.dev/minScale=1 \
        --namespace $TAP_DEV_NAMESPACE \
        --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
        --env "DOMAIN=$APPS_DOMAIN" \
        --env "JAVA_TOOL_OPTIONS=$JVM_OPTS" \
        --yes 

# Spring Config Server
yes_or_no "Run Spring Config Server?" \
    && tanzu apps workload create spring-config-server \
        --git-repo https://github.com/benwilcock/spring-config-server \
        --git-branch main \
        --type web \
        --label app.kubernetes.io/part-of=spring-config-server \
        --label tanzu.app.live.view=false \
        --annotation autoscaling.knative.dev/minScale=1 \
        --namespace $TAP_DEV_NAMESPACE \
        --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
        --env "DOMAIN=$APPS_DOMAIN" \
        --env "JAVA_TOOL_OPTIONS=$JVM_OPTS" \
        --env "SPRING_PROFILES_ACTIVE=tap" \
        --yes 

# Tanzu Java Web App (With Spring Boot Admin Integration)
yes_or_no "Run Tanzu Java Web App (With Spring Boot Admin Integration)?" \
    && tanzu apps workload create tanzu-java-web-app \
        --git-repo https://github.com/benwilcock/tanzu-java-web-app \
        --git-branch main \
        --type web \
        --label app.kubernetes.io/part-of=tanzu-java-web-app \
        --label tanzu.app.live.view=true \
        --annotation autoscaling.knative.dev/minScale=1 \
        --namespace $TAP_DEV_NAMESPACE \
        --env "NAMESPACE=$TAP_DEV_NAMESPACE" \
        --env "DOMAIN=$APPS_DOMAIN" \
        --env "JAVA_TOOL_OPTIONS=$JVM_OPTS" \
        --env "SPRING_PROFILES_ACTIVE=tap" \
        --yes

# Run from a regular image on DockerHub (no build)
yes_or_no "Run Spring Pet Clinic App (from a Docker Image)?" \
    && tanzu apps workload create petclinic-image-to-url \
  --image docker.io/benwilcock/spring-petclinic:2.6.0-SNAPSHOT \
  --type web \
  --label app.kubernetes.io/part-of=petclinic-image-to-url \
  --annotation autoscaling.knative.dev/minScale=1 \
  --namespace $TAP_DEV_NAMESPACE \
  --yes

# Adding the host entries to the hosts file (needs sudo)
# export ENVOY="$(minikube ip)"
# export HOSTS="spring-boot-admin.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN} spring-config-server.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN} tanzu-java-web-app.${TAP_DEV_NAMESPACE}.${APPS_DOMAIN}"
# message "You must add ${GREEN}'${ENVOY} ${HOSTS}'${NC} to your '/etc/hosts' file."
# message "This will enable http requests to be routed to your applications."
# echo ${ENVOY} ${HOSTS} | xclip -selection c
# yes_or_no "Opening /etc/hosts in Nano (needs sudo) for you. Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano. Ready?" \
#   && sudo nano /etc/hosts

# # Working with apps
yes_or_no "Watch the Workloads become READY?" \
    && watch --color "tanzu apps workload list; echo -e 'When the workloads are ${GREEN}Ready${NC}, press Ctrl-C to exit.'"

