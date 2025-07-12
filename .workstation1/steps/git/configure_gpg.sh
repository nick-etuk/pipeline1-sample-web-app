#!/usr/bin/env bash

configure_gpg() {
    local current_timestamp
    local gpg_dir
    local gpg_agent

    gpg_dir="$HOME/.gnupg"
    gpg_agent="$gpg_dir/gpg-agent.conf"

    if [ ! -d "$gpg_dir" ]; then
        mkdir -p "$gpg_dir"
        chmod 700 "$gpg_dir"
    fi

    if [ -f "$gpg_agent" ]; then
        current_timestamp=$(date +%Y%m%d%H%M%S)
        mv "$gpg_agent" "$gpg_agent.bak-$current_timestamp"
    fi

    if command -v pinentry-tty ;then
       command -v pinentry-tty > "$gpg_agent"
    else
        warn "pinentry-tty not found"
    fi
    
    gpg-connect-agent reloadagent /bye
}
configure_gpg
