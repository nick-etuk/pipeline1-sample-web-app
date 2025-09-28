#!/usr/bin/env bash

cleanbuild() {
    info 'Removing docker images...'
    [ -n "$(docker images -aq)" ] && docker rmi -f "$(docker images -aq)"

    info 'Pruning docker system...'
    docker system prune -f 

    info 'Installing npm packages...'
    switch_to "$REPO_DIR/nhsapp/web" && npm install && npm install -g auditjs
    switch_to "$REPO_DIR/nhsapp/web/lint" && npm install
    
    info 'Building docker images...'
    switch_to "$REPO_DIR/nhsapp" && make clean && make login && make build
}
cleanbuild