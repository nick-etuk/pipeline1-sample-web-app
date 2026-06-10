#!/usr/bin/env bash

get_personal_access_token() {
    local pat
    local option
    local short_code
    
    show_help get_personal_access_token

    if [ -n "$ONEDRIVE_HOME" ]; then
        WORKING_DIR_ONEDRIVE="$ONEDRIVE_HOME/Documents/working"
        pat=$(cat "$WORKING_DIR_ONEDRIVE/.pat")
        if [ -n "$pat" ]; then
            echo "Personal Access Token found in OneDrive, using it."
            echo "$pat" > "$WORKING_DIR/.pat"
            return
        fi
    fi

    read -rp 'Do you want to enter your Personal Access Token now [n] or later [l]' option
    [ ! "$option" = 'n' ] && return

    pat=''
    while [ -z "$pat" ]; do
        read -rp "Personal access token: " pat
    done
    echo "$pat" > "$WORKING_DIR/.pat"
    
    short_code=$(get_config 'short_code')
    [ -z "$short_code" ] && [ "$VM" = 'wsl' ] && short_code=$WINDOWS_USER
    while [ -z "$short_code" ]; do
        read -rp "Enter your HSCIC short code, for example niet2: " short_code
    done
    set_config short_code "$short_code"
}
get_personal_access_token
