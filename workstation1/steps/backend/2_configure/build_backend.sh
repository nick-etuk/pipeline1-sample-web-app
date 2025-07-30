#!/usr/bin/env bash

switch_to_backend_directory() {
    local service
    service=$1
    case $service in
        android)
            switch_to "$REPO_DIR/nhsapp-android"
            ;;
        ios)
            switch_to "$REPO_DIR/nhsapp-ios"
            ;;
        web)
            switch_to "$REPO_DIR/nhsapp/web"
            ;;
        *)
            switch_to "$REPO_DIR/nhsapp"
        ;;
    esac
}

build_backend() {
    local service
    service=$1

    switch_to_backend_directory "$service"
    # error "build backend should not run again"
    info "Building $service..."
    # if [ "$FORCE" -eq 1 ]; then
    #     # make clean
    #     # docker volume prune -af
    # fi

    case "$service" in
        web)
            npm install
            npm install -g auditjs
            switch_to "$REPO_DIR/nhsapp/web/lint"
            npm install
            ;;
        xamarinintegrationtests)
            build_backend xamarin
            ;;
    esac

    if [ "$MY_OS" = 'ubuntu' ];then
        az acr login -n nhsapp >/dev/null 2>&1
    else
        make login
    fi
    make -C "$service" build

    switch_back
}
build_backend "$1"