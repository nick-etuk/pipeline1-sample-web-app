#!/usr/bin/env bash

copy_source_file() {
    local filename="$1"
    local fullpath

    fullpath="$WORKING_DIR_ONEDRIVE/$filename"
    if [ -f "$fullpath" ]; then
        info "$filename found in OneDrive, using it."
        cp "$fullpath" "$WORKING_DIR"
    fi
}
get_personal_access_token() {
    local pat_file
    local pat
    local option
    local short_code
    
    short_code=$(get_context 'short_code')
    if [ -z "$short_code" ] && [ "$VM" = 'wsl' ]; then
        short_code=$P1_USER_WIN
    fi

    while [ -z "$short_code" ]; do
        read -rp "Enter your HSCIC short code, for example niet2: " short_code
    done

    set_context short_code "$short_code"    
    if [ -n "$WORKING_DIR_ONEDRIVE" ]; then
        copy_source_file ".pat"
        return
    fi

    info 'No Personal Access Token found.'
    read -rp 'Do you want to enter your Personal Access Token now [n] or later [l]' option
    [ ! "$option" = 'n' ] && return

    pat=''
    while [ -z "$pat" ]; do
        read -rp "Personal access token: " pat
    done
    echo "$pat" > "$WORKING_DIR/.pat"
}
get_personal_access_token
