#!/usr/bin/env bash

# 1. On WSL, copy from windows working dir if available
# 1. On macos or Ubuntu, copy from working dir if available
# (on Windows, this will be handled by the Powershell version of this script.)
# 2. On WSL, copy from WSL working dir if available
# 3. Copy from OneDrive if available
# 4. Copy from mounted keybase volume if available
# 5. Raise error if none of the above are available

mkdir -p "$HOME/.nhsonline/secrets"

if [ "$VM" = "wsl" ]; then
    if [ -d "$WORKING_DIR_WIN/keybase" ]; then
        info "Copying Keybase files from WSL working directory..."
        cp "$WORKING_DIR_WIN/keybase/"* "$HOME/.nhsonline/secrets"
        return
    fi
fi

if [ -d "$WORKING_DIR/keybase" ]; then
    info "Copying Keybase files from Pipeline1 working directory..."
    cp "$WORKING_DIR/keybase/"* "$HOME/.nhsonline/secrets"
    return
fi

if [ -n "${WORKING_DIR_ONEDRIVE+set}" ]; then
    if [ -d "$WORKING_DIR_ONEDRIVE/kb" ]; then
        info "Copying Keybase files from OneDrive..."
        cp "$WORKING_DIR_ONEDRIVE/kb/"* "$HOME/.nhsonline/secrets"
        return
    fi
fi

# todo: inmplement check for mounted keybase volume and copy from there if available
sleep 5

