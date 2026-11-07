#!/usr/bin/env bash

enable_signed_commits_ssh() {
    local git_username
    local git_email
    local signing_key

    git_username="$(git config --global user.name)"
    git_email="$(git config --global user.email)"
    if [ -z "$git_username" ] || [ -z "$git_email" ]; then
        error "Please set your git user.name and user.email before running this script."
    fi
    export GIT_USERNAME="$git_username"
    export GIT_EMAIL="$git_email"

    if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
        error "SSH public key not found at $HOME/.ssh/id_ed25519.pub"
    fi

    git config --global user.signingkey "$HOME/.ssh/id_ed25519.pub"
    git config --global gpg.format ssh

    git config --global commit.gpgsign true
    git config --global tag.gpgsign true

    touch ~/.ssh/allowed_signers
    git config --global gpg.ssh.allowedSignersFile "$HOME/.ssh/allowed_signers"

    signing_key=$(ssh-add -L | grep "ssh-ed25519" | awk '{ print $2 }')
    echo "$git_email ssh-ed25519 $signing_key" >> "$HOME/.ssh/allowed_signers"
}
