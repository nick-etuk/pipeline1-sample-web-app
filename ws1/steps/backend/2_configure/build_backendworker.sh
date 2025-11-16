#!/usr/bin/env bash

switch_to "$REPO_DIR/nhsapp"

if [ "$MY_OS" = 'ubuntu' ];then
    az acr login -n nhsapp >/dev/null 2>&1
else
    make login
fi
make -C backendworker build

switch_back
