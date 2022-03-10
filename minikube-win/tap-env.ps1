# Installation registry - contains TAP images
$Env:INSTALL_REGISTRY_HOSTNAME = "registry.tanzu.vmware.com"
$Env:INSTALL_REGISTRY_USERNAME = "wilcockb@vmware.com"
$Env:INSTALL_REGISTRY_PASSWORD = "49vTqj!SXc"

# Code and supply chain registry
$Env:REGISTRY_SERVER = "demo.goharbor.io"
$Env:REGISTRY_USERNAME = "wilcockb"
$Env:REGISTRY_PASSWORD = "Cj7ObHx7"

# TAP Installation settings
$Env:TAP_INSTALL_DIR = "~/Code/GitHub/benwilcock/scripts/tanzu-application-platform"
$Env:INSTALL_BUNDLE = "registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343"
$Env:TAP_DEV_NAMESPACE = "default"
$Env:TAP_NAMESPACE = "tap-install"

# AWS Static info...
$Env:AWS_CLUSTER_NAME = "tap"
$Env:AWS_ACCOUNT_ID = "837334766153"
$Env:AWS_REGION = "us-east-2"

# Today's AWS Secrets
$Env:AWS_ACCESS_KEY_ID = ""
$Env:AWS_SECRET_ACCESS_KEY = ""
$Env:AWS_SESSION_TOKEN = ""








