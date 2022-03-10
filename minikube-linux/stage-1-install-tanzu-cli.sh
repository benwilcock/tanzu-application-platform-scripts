################################################################
# Requires a DEDICATED *Admin* PowerShell Window               #
# Adds Tanzu CLI executable to "Programs Files"                #
# You only need to do this if you don't have Tanzu CLI already #
################################################################

# Describe this stage
echo -e "${BLUE}Stage 1 - Installing the Tanzu CLI${NC}" 
echo -e "${GREEN}This script installs the Tanzu CLI and the Tanzu CLI plugins required by TAP. If you already have the correct Tanzu CLI and plugins installed you can skip this step. Continue?${NC}"

# Source common functions & variables
source ./helper.sh

function install_cli {

  # Set env var TANZU_CLI_NO_INIT to true to insure the local downloaded versions of the CLI core and plug-ins are installed.
  export TANZU_CLI_NO_INIT=true 

  # Check the download is ready
  export CLI_FILE=tanzu-framework-linux-amd64.tar
  check_file ${CLI_FILE}

  mkdir tanzu-cli
  echo -e "${GREEN}Extracting the files from the archive.${NC}"
  tar -xvf $CLI_FILE -C ./tanzu-cli
  cd tanzu-cli

  echo -e "${GREEN}Installing the Tanzu CLI (needs sudo).${NC}"
  sudo install cli/core/v0.11.1/tanzu-core-linux_amd64 /usr/local/bin/tanzu

  # Install the Tanzu CLI Plugins
  tanzu plugin install --local cli all

  # Adding the PATH entry
  # PATH_ADD="/usr/local/bin/tanzu;"
  # echo -e "${GREEN}You need to add '${ENVOY} ${HOSTS}' to your /etc/hosts file${NC}"
  # echo ${ENVOY} ${HOSTS} | xclip -selection c
  # yes_or_no "$( echo -e ${WHITE}"Opening /etc/hosts for you in Nano (needs sudo). Use Ctrl+Shift+V to add the new line. Ctrl-X to exit Nano. OK?"${NC})" \
  #   && sudo nano /etc/hosts

  # Tidy up the extracted folder
  cd ..
  rm -rf tanzu-cli
}

install_cli

# Check the correct version is now installed
tanzu version

# Check the correct version is now installed
tanzu plugin list

# Continue with the install?
yes_or_quit "$( echo -e "${GREEN}Do the plugins: ${WHITE}package, secret, apps, services, and accelerator${GREEN} have the status 'installed' in the list above?${NC}" )"


echo -e "${GREEN}Next, run the stage-2 script.${NC}"