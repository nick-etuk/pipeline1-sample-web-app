#!/usr/bin/env bash
# shellcheck disable=SC2016

install_gpg_macos() {
    brew install gpg
}

install_gpg_ubuntu() {
    sudo apt-get install -y gnupg
}

update_profile() {
    local profile

    profile=$1
    [ -z "$profile" ] && return

    if grep -q 'export GPG_TTY=$(tty)' "$profile"; then
        return
    fi

    echo -e '\nexport GPG_TTY=$(tty)' >> "$profile"
}

install_gpg_"$MY_OS"

update_profile "$HOME/.zshrc"
update_profile "$HOME/.bashrc"

GPG_TTY=$(tty)
export GPG_TTY
