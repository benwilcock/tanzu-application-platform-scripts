# Set a bunch of environment variables we will use during the installation process
. .\tap-env.ps1

# Set env var TANZU_CLI_NO_INIT to true to assure the local downloaded versions of the CLI core and plug-ins are installed.
$Env:TANZU_CLI_NO_INIT=true 

# Get the Tanzu Network Tokens required
$r = Invoke-WebRequest -Method POST -Uri https://network.pivotal.io/api/v2/authentication/access_tokens -Headers @{'refresh_token' = $env:TANZU_NETWORK_TOKEN}
$Env:ACCESS_TOKEN=$(echo ${TOKEN} | jq -r .access_token)

# Login to Tanzu Network using the new token
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer ${ACCESS_TOKEN}" -X GET https://network.pivotal.io/api/v2/authentication

# Download the Tanzu Command line (Linux) from Tanzu Network
rm -rf $TAP_INSTALL_DIR/tanzu-cli # Remove previously downloaded cli files
mkdir $TAP_INSTALL_DIR/tanzu-cli
wget https://network.pivotal.io/api/v2/products/tanzu-application-platform/releases/1043418/product_files/1147349/download --header="Authorization: Bearer ${ACCESS_TOKEN}" -O $TAP_INSTALL_DIR/tanzu-cli/tanzu-framework-linux-amd64-0.11.1.tar
tar -xvf $TAP_INSTALL_DIR/tanzu-cli/tanzu-framework-linux-amd64-0.11.1.tar -C $TAP_INSTALL_DIR/tanzu-cli

# Uninstall the old Tanzu Command Line
rm -rf $HOME/tanzu/cli        # Remove previously downloaded cli files
sudo rm /usr/local/bin/tanzu  # Remove CLI binary (executable)
rm -rf ~/.config/tanzu/       # current location # Remove config directory
rm -rf ~/.tanzu/              # old location # Remove config directory
rm -rf ~/.cache/tanzu         # remove cached catalog.yaml
rm -rf ~/Library/Application\ Support/tanzu-cli/* # Remove plug-ins

# Install the new Tanzu command line (linux)
cd $TAP_INSTALL_DIR/tanzu-cli
sudo install cli/core/v0.11.1/tanzu-core-linux_amd64 /usr/local/bin/tanzu

# Check the correct version is now installed
tanzu version

# Install the Tanzu CLI Plugins
tanzu plugin install --local cli all
tanzu plugin list

