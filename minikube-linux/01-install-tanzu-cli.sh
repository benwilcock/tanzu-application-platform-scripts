################################################################
# Adds Tanzu CLI executable to PATH                            #
# You only need to do this if you don't have Tanzu CLI already #
################################################################

# Source common functions & variables
source ./helper.sh

# Describe this stage
title "Stage 1 - Installing the Tanzu CLI" 
sub_title "This script installs the Tanzu CLI version ${TANZU_CLI_VERSION} and the Tanzu CLI plug-ins required by TAP."
message "If you already have the correct Tanzu CLI and plug-ins installed you can skip this step."

function install_cli {

  # Set env var TANZU_CLI_NO_INIT to true to insure the local downloaded versions of the CLI core and plug-ins are installed.
  export TANZU_CLI_NO_INIT="true" 

  # Check the download is ready
  check_file ${CLI_FILE}

  mkdir tanzu-cli
  message "${GREEN}Extracting the install files from the archive.${NC}"
  tar -xvf ${CLI_FILE} -C ./tanzu-cli
  cd tanzu-cli

  message "${GREEN}Installing the Tanzu CLI (needs sudo).${NC}"
  sudo install cli/core/${TANZU_CLI_VERSION}/tanzu-core-linux_amd64 /usr/local/bin/tanzu

  # Install the Tanzu CLI Plugins
  tanzu plugin install --local cli all

  # Tidy up the extracted folder
  cd ..
  rm -rf tanzu-cli
}

yes_or_no "Install the Tanzu CLI and its plug-ins?" \
  && install_cli

# Check the correct version is now installed
tanzu version

# Check the correct version is now installed
tanzu plugin list

# Continue with the install?
yes_or_quit "In the list above do the plugins: ${WHITE}package, secret, apps, services, insight, and accelerator${YELLOW} have a status of 'installed'?"

