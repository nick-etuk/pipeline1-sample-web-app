#!/usr/bin/env bash

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
    true
}

start_keybase_"$MY_OS"
sleep 5
