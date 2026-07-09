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

    mkdir -p "$REPO_DIR"
    switch_to "$REPO_DIR"
    [ ! -d nhsapp ] && git clone https://github.com/NHSDigital/nhsapp.git
    # [ ! -d nhsapp-vue-component-library ] && git clone https://github.com/NHSDigital/nhsapp-vue-component-library.git
    [ ! -d nhsapp-android ] && git clone https://github.com/NHSDigital/nhsapp-android.git
    [ ! -d nhsapp-ios ] && git clone https://github.com/NHSDigital/nhsapp-ios.git
}
clone_application_repos