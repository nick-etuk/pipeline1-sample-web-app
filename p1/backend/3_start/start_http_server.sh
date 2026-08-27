#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1091

check_hosts_file() {
    local bitraft_ip_address
    bitraft_ip_address=$(ping -q -W1 -c1 web.local.bitraft.io | head -n1 | cut -d "(" -f2 | cut -d ")" -f1)
    if [ "$bitraft_ip_address" != '127.0.0.1' ]; then
        warn 'Hosts file is not configured correctly.'
        warn 'On Windows or WSL, please add the contents of web_hosts.txt'
        warn 'to C:\Windows\System32\drivers\etc\hosts and try again.'
        warn 'On macOs or Linux, please run update_hosts_file.sh and try again.'
        exit 1
    fi
}

start_http_server() {
    local stale_nginx_container
    local node_major_ver

    # switch_to "$REPO_DIR/nhsapp/web/lint"
    # npm install
    # This always installs 200 plus packages.
    # Restore the lines above when you have fixed that.
    
    if command -v node >/dev/null 2>&1; then
        debug "Using existing Node $(node -v)"
    else
        activate_node
    fi

    node_major_ver=$(node -v | cut -d. -f1 | tr -d v)
    if [ "$node_major_ver" -lt "$NODE_MAJOR_VERSION" ]; then
        activate_node
    fi

    switch_to "$REPO_DIR/nhsapp/web"
    # npm install
    # npm i --no-save --prefix ./node_modules/express path-to-regexp@0.1.7 #todo: remove this when develop is fixed
    # docker kill $(docker ps -q --filter 'publish=8089')
    stale_nginx_container=$(docker ps -q --filter 'publish=8089')
    if [ -n "$stale_nginx_container" ]; then
        warn "Killing stale nginx container on port 8089: $stale_nginx_container"
        docker kill "$stale_nginx_container"
    fi
    npm run docker-dev
}

check_hosts_file
start_http_server
