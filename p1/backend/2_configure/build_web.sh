#!/usr/bin/env bash

switch_to "$REPO_DIR/nhsapp/web"

# npm install
# npm install -g auditjs
switch_to "$REPO_DIR/nhsapp/web/lint"
# npm install

switch_to "$REPO_DIR/nhsapp"

if [ "$MY_OS" = 'ubuntu' ];then
    az acr login -n nhsapp >/dev/null 2>&1
else
    make login
fi
make -C web build

switch_back
