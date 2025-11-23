#!/usr/bin/env bash
# shellcheck disable=SC2016

install_gpg_macos() {
    brew install gpg
}

install_gpg_ubuntu() {
    local tmp_dir
    sudo apt-get install -y build-essential bzip2 libassuan-dev libgcrypt20-dev libgpg-error-dev libksba-dev libnpth0-dev
    
    tmp_dir=$(mktemp -d)
    cd "$tmp_dir" || exit 1

    echo "Compiling gnupg. Working in temporary directory $tmp_dir"
    
    compile_source_libgpg_error "$tmp_dir"
    compile_source_libksba "$tmp_dir"
    compile_source_gpg_v3 "$tmp_dir"
}

update_profile() {
    local profile

    profile=$1
    [ -z "$profile" ] && return

    if grep -q 'export GPG_TTY=$(tty)' "$profile"; then
        return
    fi

    # echo -e '\nexport GPG_TTY=$(tty)' >> "$profile"
    # shellcheck disable=SC2059
    printf "\nexport GPG_TTY=$(tty)\n" >> "$profile"
}

install_gpg_"$MY_OS"

update_profile "$HOME/.zshrc"
update_profile "$HOME/.bashrc"

GPG_TTY=$(tty)
export GPG_TTY
