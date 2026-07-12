#!/usr/bin/env bash

start_backendworker() {
    local login_env

    login_env=$(get_context 'login_env')
    if [ -z "$login_env" ]; then
        warn "login_env not set, defaulting to 'ext'"
        login_env='ext'
    fi
    debug "login_env: $login_env"

    switch_to "$REPO_DIR/nhsapp"
    if [ "$MY_OS" = 'ubuntu' ];then
        az acr login -n nhsapp >/dev/null 2>&1
    else
        make login
    fi
    
    WEB=host LOGINENV="$login_env" make run 
}

start_backendworker
switch_to "$REPO_DIR/nhsapp"
