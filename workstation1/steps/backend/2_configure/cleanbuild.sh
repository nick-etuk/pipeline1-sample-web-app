#!/usr/bin/env bash

cleanbuild() {
    local node_modules
    local node_module
    local choice

    if [ -n "$(docker ps -a -q)" ]; then
        info 'Stopping and removing docker containers...'
        docker stop "$(docker ps -a -q)"
        docker rm "$(docker ps -a -q)"
    fi
    if [ -n "$(docker ps -a -q)" ]; then
        read -rp "Failed to stop docker containers. Continue? (y/n) " choice
        case "$choice" in
            y|Y ) info "Continuing...";;
            n|N ) error "Exiting..."; exit 1;;
            * ) error "Invalid choice. Exiting..."; exit 1;;
        esac
    fi

    info 'Removing docker images...'
    if [ -n "$(docker images -aq)" ]; then
        if ! docker rmi -f "$(docker images -aq)"; then
            read -rp "Failed to remove docker images. Continue? (y/n) " choice
            case "$choice" in
                y|Y ) info "Continuing...";;
                n|N ) error "Exiting..."; exit 1;;
                * ) error "Invalid choice. Exiting..."; exit 1;;
            esac
        fi
    fi

    info 'Pruning docker system...'
    docker system prune -f 

    info 'Deleting node_modules...'
    switch_to "$REPO_DIR/nhsapp"
    # find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
    node_modules=$(find . -name 'node_modules' -type d -prune)
    for node_module in $node_modules; do
        if [ -d "$node_module" ]; then
            if [ "$(stat -c '%U' "$node_module")" = "root" ]; then
                sudo rm -rf "$node_module"
            else
                rm -rf "$node_module"
            fi
            [ -d "$node_module" ] && error "Failed to remove $node_module"
        else
            warn "$node_module not found, skipping"
        fi
    done

    info 'Installing npm packages...'
    npm install -g auditjs
    switch_to "$REPO_DIR/nhsapp/web"
    npm install
    switch_to "$REPO_DIR/nhsapp/web/lint"
    npm install
    
    info 'Building docker images...'
    switch_to "$REPO_DIR/nhsapp" && make clean && make login && make build
}
cleanbuild