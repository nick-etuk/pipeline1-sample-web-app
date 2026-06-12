#!/usr/bin/env bash

if [ -n "$ONEDRIVE_HOME" ]; then
    WORKING_DIR_ONEDRIVE="$ONEDRIVE_HOME/Documents/working"
    if [ -d "$WORKING_DIR_ONEDRIVE/kb" ]; then
        cp "$WORKING_DIR_ONEDRIVE/kb/"* "$HOME/.nhsonline/secrets"
        echo "Keybase files copied from OneDrive."
        return
    else
        warn "Keybase directory not found in OneDrive at $WORKING_DIR_ONEDRIVE/kb"
    fi
fi

if [ ! -d /mnt/c/provisioning/working/keybase ]; then
    warn "Keybase directory not found at /mnt/c/provisioning/working/keybase"
    return
fi

cp /mnt/c/provisioning/working/keybase/* "$HOME/.nhsonline/secrets"
sleep 5

