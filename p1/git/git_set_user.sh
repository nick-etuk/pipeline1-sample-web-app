#!/usr/bin/env bash


set_git_user() {
    local user_type
    local current_email
    local git_email
    local git_username
    local ssh_key

    user_type="$1"
    current_email=$(git config user.email)
    case "$user_type" in
        'nhs')
            git_email='nick.etuk2@nhs.net'
            ssh_key="$HOME/.ssh/id_ed25519_nhs.pub"
            ;;
        'hotmail')
            git_email='nick_etuk@hotmail.com'
            ssh_key="$HOME/.ssh/id_ed25519_nick_etuk.pub"
            ;;
        'yahoo')
            git_email='netuk3@yahoo.co.uk'
            ssh_key="$HOME/.ssh/id_ed25519_nick_etuk.pub"
            ;;
        *)
            warn "Invalid user type: $user_type. Must be one of: nhs, hotmail or yahoo."
            return 1
        ;;
        esac
    }

    # Commit signing is only required for nhs repos
    if [ "$user_type" = "nhs"]; then
        git config gpg.format ssh
        git config commit.gpgsign true
        git config tag.gpgsign true

        git config user.signingkey "$HOME/.ssh/$ssh_key.pub"
        git config --global gpg.ssh.allowedSignersFile "$HOME/.ssh/allowed_signers"
    fi
}

set_git_user $user_type
