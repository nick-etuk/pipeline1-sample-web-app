#!/usr/bin/env bash

clone_application_repos() {
    git config --global pull.rebase true
    git config --global push.default current
    git config --global core.autocrlf false
    git config --global fetch.prune true
    git config --global fetch.pruneTags true

    # git config --global push.autoSetupRemote true
    git config --global core.pager 'less -FRX'
    git config --global core.editor "code --wait"
    git config --global rerere.enabled false
    git config --global color.ui true
    git config --global alias.ch checkout
    git config --global branch.sort -committerdate
    git config --global column.ui auto

    mkdir -p "$REPO_DIR_UNIX"
    switch_to "$REPO_DIR_UNIX"
    git clone https://nhsapp@dev.azure.com/nhsapp/NHS%20App/_git/nhsapp
    git clone https://nhsapp@dev.azure.com/nhsapp/NHS%20App/_git/nhsapp-vue-component-library
    git clone https://nhsapp@dev.azure.com/nhsapp/NHS%20App/_git/nhsapp-android
    git clone https://nhsapp@dev.azure.com/nhsapp/NHS%20App/_git/nhsapp-ios
    git clone https://nhsapp@dev.azure.com/nhsapp/NHS%20App/_git/nhsapp-utilities-api-adapter
}
