#!/usr/bin/env bash

configure_gpg() {
    local current_timestamp
    local gpg_dir
    local gpg_agent_config

    gpg_dir="$HOME/.gnupg"
    gpg_agent_config="$gpg_dir/gpg-agent.conf"

    if [ ! -d "$gpg_dir" ]; then
        mkdir -p "$gpg_dir"
        chmod 700 "$gpg_dir"
    fi

    if [ -f "$gpg_agent_config" ]; then
        current_timestamp=$(date +%Y%m%d%H%M%S)
        mv "$gpg_agent_config" "$gpg_agent_config.bak-$current_timestamp"
    fi

    if command -v pinentry-tty ;then
       echo "pinentry-program $(command -v pinentry-tty)" > "$gpg_agent_config"
    else
        warn "pinentry-tty not found"
    fi
    
    gpg-connect-agent reloadagent /bye
}
configure_gpg
