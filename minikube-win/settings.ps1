################################################################
# Requires a DEDICATED *Admin* PowerShell Window               #
# Adds Tanzu CLI executable to "Programs Files"                #
# You only need to do this if you don't have Tanzu CLI already #
################################################################

# Get the working directory
$Env:PWD = pwd

# Get ready to add plugins to the tool
$Env:TANZU_CLI_NO_INIT = "true" 

# Tanzu CLI Version
$Env:TANZU_CLI_VERSION = "v0.25.0"

# Choose where Built container images will go...
$Env:REPOSITORY_TYPE = "dockerhub" # One of "dockerhub" "harbor" "local"

# Specify the version of TAP to install
$Env:TAP_VERSION = "1.1.0-build.17" # "1.1.0-build.5" # "1.0.1" "1.0.2-build.8"

# Namespace for the TAP installation components
$Env:TAP_NAMESPACE = "tap-install"

# Set a domain for the apps to live in
$Env:DOMAIN = "example.com"

# Set a domain for the apps to live in
$Env:APPS_DOMAIN = "apps.example.com"

# Set a developer namespace name
$Env:TAP_DEV_NAMESPACE = "default" 