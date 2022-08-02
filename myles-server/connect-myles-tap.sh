#!/bin/bash

source ./helper.sh

check_for_vpn

kubectl vsphere login --insecure-skip-tls-verify \
 --server=$VSPHERE_SERVER \
 -u $VSPHERE_USER \
 --tanzu-kubernetes-cluster-name tap-view

kubectl vsphere login --insecure-skip-tls-verify \
 --server=$VSPHERE_SERVER \
 -u $VSPHERE_USER \
 --tanzu-kubernetes-cluster-name tap-build

kubectl vsphere login --insecure-skip-tls-verify \
 --server=$VSPHERE_SERVER \
 -u $VSPHERE_USER \
 --tanzu-kubernetes-cluster-name tap-run

kubectl vsphere login --insecure-skip-tls-verify \
 --server=$VSPHERE_SERVER \
 -u $VSPHERE_USER \
 --tanzu-kubernetes-cluster-name tap-run-2

kubectl vsphere login --insecure-skip-tls-verify \
 --server=$VSPHERE_SERVER \
 -u $VSPHERE_USER \
 --tanzu-kubernetes-cluster-name tap-ga

yes_or_no "Switch Kubectl's context to $TARGET_CLUSTER?" && \
 kubectx $TARGET_CLUSTER

yes_or_no "Open the TAP GUI in Google Chrome?" && \
 nohup google-chrome --disable-gpu $TAP_GUI_URL  &>/dev/null
