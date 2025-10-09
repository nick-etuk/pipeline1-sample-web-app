#!/usr/bin/env bash
# shellcheck disable=SC2154

start_service() {
    local service
    local login_env
    local stale_nginx_container
    local node_major_ver

    # local args
    # local service_args

    # args=("$@")
    # service=${args[0]}
    # service_args=("${args[@]:1}")
    # service_args_len=${#service_args[@]}
    # debug "Starting service: $service with args ${service_args[*]+"${service_args[*]}"}"

    # if [ "$service_args_len" -gt 0 ]; then
    #     login_env=${service_args[0]}
    #     default_login_env=$(get_config 'login_env')
    #     if [ "$default_login_env" != "$login_env" ]; then
    #         warn "Changing default LOGINENV from '$login_env' to '$default_login_env'"
    #         set_config 'login_env' "$default_login_env"
    #     fi
    # else
    #     login_env=$(get_config 'login_env')
    # fi

    service=$1
    debug "Starting service: $service"

    if  [ "$service" != 'http_server' ]; then
        login_env=$(get_config 'login_env')
        if [ -z "$login_env" ]; then
            warn "login_env not set, defaulting to 'ext'"
            login_env='ext'
        fi
        debug "login_env: $login_env"
    fi

    switch_to "$REPO_DIR/nhsapp"
    if [ "$service" != 'http_server' ]; then
        if [ "$MY_OS" = 'ubuntu' ];then
            az acr login -n nhsapp >/dev/null 2>&1
        else
            make login
        fi
    fi
    
    case $service in
        android)
            make run-android
            ;;
        backendworker)
            WEB=host LOGINENV="$login_env" make run 
            ;;
        # backend_and_http)
            # make run WEB=host LOGINENV="$login_env" # this will never exit. Rethink this line.
            # sleep 10
            # exit_status=$WAIT_FOR_STEP_STATUS
            # debug "wait_for_step exit_status: $exit_status"
            # [ "$exit_status" -ne 0 ] && return "$exit_status"
            # run_step start_http_server
            # ;;
        bdd)
            debug "=>start_service: bdd"
            switch_to "$REPO_DIR/nhsapp/web"
            npm install
            switch_to "$REPO_DIR/nhsapp"
            make run-localbdd
            ;;
        http_server)
            # switch_to "$REPO_DIR/nhsapp/web/lint"
            # npm install
            # This always installs 200 plus packages.
            # Restore the lines above when you have fixed that.
            
            debug "Node version: $(node -v)"
            node_major_ver=$(node -v | cut -d. -f1 | tr -d v)
            if [ "$node_major_ver" -lt "$NODE_MAJOR_VERSION" ]; then
                warn "Node version $NODE_MAJOR_VERSION or higher is required. Current version is $(node -v)"
                warn "Attempting to switch to Node version $NODE_MAJOR_VERSION using nvm"
                export NVM_DIR="$HOME"/.nvm
                debug "NVM_DIR: $NVM_DIR"
                if [ -s "$NVM_DIR"/nvm.sh ]; then
                    source "$NVM_DIR"/nvm.sh
                    nvm use "$NODE_MAJOR_VERSION"
                    debug "New Node version: $(node -v)"
                else
                    error "nvm.sh not found in $NVM_DIR"
                fi
                node_major_ver=$(node -v | cut -d. -f1 | tr -d v)
                if [ "$node_major_ver" -lt "$NODE_MAJOR_VERSION" ]; then
                    error "Could not switch to Node $NODE_MAJOR_VERSION"
                fi
            fi

            switch_to "$REPO_DIR/nhsapp/web"
            npm install
            npm i --no-save --prefix ./node_modules/express path-to-regexp@0.1.7 #todo: remove this when develop is fixed
            # docker kill $(docker ps -q --filter 'publish=8089')
            stale_nginx_container=$(docker ps -q --filter 'publish=8089')
            if [ -n "$stale_nginx_container" ]; then
                warn "Killing stale nginx container on port 8089: $stale_nginx_container"
                docker kill "$stale_nginx_container"
            fi
            npm run docker-dev
            ;;
        xamarinintegrationtests)
            make -C xamarinintegrationtests run-local
            ;;
        *)
            error "unknown service $service"
            ;;

    esac

    switch_back
}

start_service "$@"
