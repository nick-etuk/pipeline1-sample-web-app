#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1091

start_http_server_no_backend() {
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
    npm run start-dev
}

start_http_server_no_backend
