#!/usr/bin/env bash

install_docker_macos() {
    brew install colima
}

install_docker_ubuntu() {
    echo "=>install_docker_ubuntu"

    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg; 
    done
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    VERSION_CODENAME=$(lsb_release -cs)
    sudo echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo update-rc.d docker defaults
    sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
}
echo "=>install docker. MY_OS: $MY_OS"
install_docker_"$MY_OS"
