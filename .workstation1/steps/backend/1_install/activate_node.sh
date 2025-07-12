#!/usr/bin/env bash

activate_node() {
    local nvm_command
    
    nvm_command="$HOME"/.nvm/nvm.sh
    [ -f "$nvm_command" ] || {
        warn "NVM is not installed or the path is incorrect: $nvm_command"
        return
    }

    source "$nvm_command"
    nvm use $NODE_MAJOR_VERSION

    if [ $? -ne 0 ]; then
        error "Failed to activate Node.js version $NODE_MAJOR_VERSION with NVM"
        return
    fi
    nvm alias default $NODE_MAJOR_VERSION
}
activate_node