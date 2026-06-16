#!/usr/bin/env bash

install_keybase_macos() {
    brew update && brew install keybase
}

install_keybase_wsl() {
    warn 'Keybase installation not yet implemented for WSL'
}

install_keybase_ubuntu() {
    [ "$VM" = 'wsl' ] && install_keybase_wsl

    warn 'Keybase installation not yet implemented for ubuntu'
}

if [ -n "$ONEDRIVE_HOME" ]; then
    WORKING_DIR_ONEDRIVE="$ONEDRIVE_HOME/Documents/working"
    if [ -d "$WORKING_DIR_ONEDRIVE/kb" ]; then
        info "No need to install keybase. Using local files."
        mkdir -p "$HOME/.nhsonline/secrets"
        return
    fi
fi

function mount_keybase_volume {
    if [ -d "/Volumes/Keybase/team/nhsonline" ]; then
        MOUNT_ATTEMPTS=$((MOUNT_ATTEMPTS+1))
        if [ $MOUNT_ATTEMPTS -gt 4 ]; then
            warn "Could not mount Keybase volume after 5 attempts. Please mount it manually."
            return 1
        fi 
        warn "Keybase volume not yet mounted. Trying again in 10 seconds..."
        sleep 10
        mount_keybase_volume
    fi
}

function start_keybase_macos {
    open /Applications/Keybase.app

    MOUNT_ATTEMPTS=0
    mount_keybase_volume
}

function start_keybase_ubuntu {
    info 'No yet implemented: start_keybase_ubuntu'
}

install_keybase_"$MY_OS"

start_keybase_"$MY_OS"
sleep 5

