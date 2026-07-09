#!/usr/bin/env bash

add_docker_group() {
    if ! groups | grep -q "\bdocker\b"; then
        info 'Adding docker group'
        sudo groupadd docker
    fi

    info "Adding user $P1_USER_UNIX to docker group"
    sudo usermod -aG docker "$P1_USER_UNIX"
    info "${YELLOW}User $P1_USER_UNIX added to docker group. You may need to log out and log back in for this to take effect.${NC}"

    # if ! getent group docker > /dev/null 2>&1; then
    #     info "Adding user $P1_USER_UNIX to docker group..."
    #     sudo groupadd docker
    #     sudo usermod -aG docker "$P1_USER_UNIX"
    #     info "${YELLOW}User $P1_USER_UNIX added to docker group. You may need to log out and log back in for this to take effect.${NC}"
    # else
    #     info "${YELLOW}Docker group already exists. Skipping adding user to docker group.${NC}"
    # fi
    
}

add_docker_group
