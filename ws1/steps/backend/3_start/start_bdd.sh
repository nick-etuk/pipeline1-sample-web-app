#!/usr/bin/env bash

start_bdd() {
    local login_env

    # Prompt for confirmation
    read -rp "Remember to run 'make -C web build' before running BDD tests. Press Enter to continue..." response
 
    debug "=>start_bdd"
    switch_to "$REPO_DIR/nhsapp/web"
    npm install

    login_env=$(get_config 'login_env')
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
    
    make run-localbdd
 
    switch_back
}

start_bdd