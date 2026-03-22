#!/usr/bin/env bash

enable_signed_commits() {
    local git_username
    local git_email
    local signing_key
    local key_id
    local public_key

    git_username="$(git config --global user.name)"
    git_email="$(git config --global user.email)"
    if [ -z "$git_username" ] || [ -z "$git_email" ]; then
        error "Please set your git user.name and user.email before running this script."
    fi
    export git_username
    export git_email

    gpg-connect-agent reloadagent /bye

    gpg --batch --gen-key <<EOF
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Name-Real: ${git_username} (NHS)
Name-Email: ${git_email}
Expire-Date: 0
EOF
    # Enter a secure password when prompted

    signing_key=$(gpg --list-secret-keys --keyid-format=long | grep \(NHS\) -B2 | head -n 1 | sed "s/^.*\///" | awk '{ print $1 }')
    git config --global user.signingkey "$signing_key"
    git config --global commit.gpgSign true

    key_id=$(gpg --list-public-keys | grep \(NHS\) -B 1 | head -n 1 | awk '{ print $1 }')
    public_key=$(gpg --export --armor "$key_id")

    info 'Your public key is shown below'
    info 'Please add it to your GitHub account'
    info 'Log into GitHub.'
    info 'Click your profile icon at the top right.'
    info 'Select Settings.'
    info 'From the menu on the left, select SSH & GPG keys.'
    info 'Click New GPG key.'
    info 'Name it "NHS".'
    info 'Paste the public key into the Key field.'
    info 'Click Add GPG key.'
    info ''
    info "$public_key"
    info 'Press any key to continue...'
    read -r -n 1 -s
    echo
}

enable_signed_commits