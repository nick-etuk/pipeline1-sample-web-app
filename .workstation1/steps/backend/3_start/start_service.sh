#!/usr/bin/env bash
# shellcheck disable=SC2154

start_service() {
    local service
    local login_env
    local stale_nginx_container
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

    login_env=$(get_config 'login_env')
    if [ -z "$login_env" ]; then
        warn "login_env not set, defaulting to 'ext'"
        login_env='ext'
    fi
    debug "login_env: $login_env"

    switch_to "$REPO_DIR/nhsapp"
    if [ "$service" != 'http_server' ]; then
        if [ "$MY_OS" = 'ubuntu' ];then
            az acr login -n nhsapp >/dev/null 2>&1
        else
            make login
        fi
    fi

    # docker kill $(docker ps -q --filter 'publish=8089')
    stale_nginx_container=$(docker ps -q --filter 'publish=8089')
    if [ -n "$stale_nginx_container" ]; then
        warn "Killing stale nginx container on port 8089: $stale_nginx_container"
        docker kill "$stale_nginx_container"
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
            # This always installs 200 plus packages.
            # Restore the lines below when this is fixed.
            # switch_to "$REPO_DIR/nhsapp/web/lint"
            # npm install
            switch_to "$REPO_DIR/nhsapp/web"
            npm install
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
