#!/usr/bin/env bash

get_personal_access_token() {
    local pat_file
    local pat
    local option
    local short_code
    
    if [ -n "$WORKING_DIR_ONEDRIVE" ]; then
        pat_file="$WORKING_DIR_ONEDRIVE/.pat"
        if [ -f "$pat_file" ]; then
            pat=$(cat "$pat_file")
            if [ -n "$pat" ]; then
                echo "Personal Access Token found in OneDrive, using it."
                echo "$pat" > "$WORKING_DIR/.pat"
                return
            fi
        fi
    fi

    info 'No Personal Access Token found.'
    read -rp 'Do you want to enter your Personal Access Token now [n] or later [l]' option
    [ ! "$option" = 'n' ] && return

    pat=''
    while [ -z "$pat" ]; do
        read -rp "Personal access token: " pat
    done
    echo "$pat" > "$WORKING_DIR/.pat"
    
    short_code=$(get_context 'short_code')
    [ -z "$short_code" ] && [ "$VM" = 'wsl' ] && short_code=$P1_USER_WIN
    while [ -z "$short_code" ]; do
        read -rp "Enter your HSCIC short code, for example niet2: " short_code
    done
    set_context short_code "$short_code"
}
get_personal_access_token
