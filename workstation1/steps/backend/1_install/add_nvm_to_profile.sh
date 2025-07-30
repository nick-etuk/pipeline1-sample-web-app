#!/usr/bin/env bash
# shellcheck disable=SC2129,SC2016

# debug '*** running install_node.sh ***'
# return 0

add_nvm_to_profile() {
    local profile
    profile="$1"

    [ -z "$profile" ] && return
    if grep -q 'NVM_DIR' "$profile"; then
        info "NVM is already added to $profile"
        return
    fi
    [ ! -f "$profile" ] && return
    [ ! -d "$HOME"/.nvm ] && return

    info "Adding NVM to $profile"
    echo 'export NVM_DIR="$HOME"/.nvm' >> "$profile"
    echo '[ -s "$NVM_DIR"/nvm.sh ] && \. "$NVM_DIR"/nvm.sh' >> "$profile"
    echo '[ -s "$NVM_DIR"/bash_completion ] && \. "$NVM_DIR"/bash_completion' >> "$profile"
}

add_nvm_to_profile "$HOME"/.bashrc
add_nvm_to_profile "$HOME"/.zshrc

