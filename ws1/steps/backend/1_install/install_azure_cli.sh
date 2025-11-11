#!/usr/bin/env bash

install_azure_cli_ubuntu() {
    # curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash # this no loger works
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

    VERSION_CODENAME=$(lsb_release -cs)
    # echo "Types: deb URIs: https://packages.microsoft.com/repos/azure-cli/ Suites: ${VERSION_CODENAME} \
    # Components: main Architectures: $(dpkg --print-architecture) Signed-by: /etc/apt/keyrings/microsoft.gpg" | \

    echo -e "Types: deb\nURIs: https://packages.microsoft.com/repos/azure-cli/\nSuites: ${VERSION_CODENAME}\nComponents: main\nArchitectures: $(dpkg --print-architecture)\nSigned-by: /etc/apt/keyrings/microsoft.gpg" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.sources

    sudo apt-get update
    sudo apt-get install -y azure-cli
}

install_azure_cli_macos() {
    brew update && brew install azure-cli
}
install_azure_cli_"$MY_OS"
