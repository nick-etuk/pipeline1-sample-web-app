#!/usr/bin/env bash

install_dotnet_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y "dotnet-sdk-$DOTNET_MAJOR_VERSION.0"
}

install_dotnet_macos() {
    echo 'for now, please install dotnet manually on macOS.'
    # curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel $DOTNET_MAJOR_VERSION --install-dir $DOTNET_INSTALL_DIR
    # export PATH="$DOTNET_INSTALL_DIR:$PATH"
}

install_dotnet_$MY_OS
