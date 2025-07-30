#!/usr/bin/env bash

function install_docker_ubuntu {
    install_build_tools_linux
}

function install_build_tools_macos {
    brew install make
}

function install_build_tools_linux {
    apt-get install -y build-essential
}

install_build_tools_"$MY_OS"
    