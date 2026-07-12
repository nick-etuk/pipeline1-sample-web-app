#!/usr/bin/env bash
# shellcheck disable=SC2016

debug 'check failed: test -f ~/.nvm/nvm.sh'
debug '*** installing nvm and node ***'

add_nvm_to_profile() {
    local profile
    profile="$1"

    [ -z "$profile" ] && return
    grep -q 'NVM_DIR' "$profile" && return
    [ ! -f "$profile" ] && return
    [ ! -d "$HOME/.nvm" ] && return

    info "Adding NVM to $profile"
    echo 'export NVM_DIR="$HOME/.nvm"' >> "$profile"
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME"/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> "$HOME"/.bashrc
}

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep 'tag_name' | cut -d\" -f4)/install.sh | bash

# no longer needed. Done by edit_login_profile.sh
# add_nvm_to_profile "$HOME/.bashrc"
# add_nvm_to_profile "$HOME/.zshrc"

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    nvm install "$NODE_MAJOR_VERSION"
    nvm alias default "$NODE_MAJOR_VERSION"
    nvm use default
fi
