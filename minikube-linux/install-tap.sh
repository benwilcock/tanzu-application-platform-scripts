#!/bin/bash

# Source common functions & variables
source ./helper.sh

. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/01-install-tanzu-cli.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/02-start-minikube.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/03-install-tce.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/04-install-platform.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/05-create-workspace.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/06-run-workload.sh"
. "/home/ben/Code/GitHub/benwilcock/tanzu-application-platform-scripts/minikube-linux/07-test-workload.sh"
