function switch_git_user {
    # Don't do this. Set the git user email and signing key locally for each repo instead.
    $current_email = (git config user.email)
    switch($current_email) {
        nick.etuk2@nhs.net {
           $email = 'nick_etuk@hotmail.com'
           $public_key_file = "$HOME\.ssh\id_ed25519_nick-etuk.pub"
        }
        nick_etuk@hotmail.com {
            $email = 'nick.etuk2@nhs.net'
            $public_key_file = "$HOME\.ssh\id_ed25519.pub"
        }
        default {
            WriteWarn "Invalid git email: $current_email"
            return
        }
    }

    git config user.email nick_etuk2@hotmail.com
    git config user.signingkey "$HOME\.ssh\id_ed25519_nick-etuk.pub"
    git config --global gpg.format ssh
    # git config --global core.sshCommand "'C:\Windows\System32\OpenSSH\ssh.exe'"
    git config --global core.sshCommand "`'$((Get-Command ssh.exe).Source)`'"
    git config --global gpg.ssh.program (Get-Command ssh-keygen.exe).Source

    git config --global commit.gpgsign true
    git config --global tag.gpgsign true


    git config --global gpg.ssh.allowedSignersFile $HOME/.ssh/allowed_signers

    $key = (Get-Content $HOME/.ssh/id_ed25519.pub)
    $signer = "$email $key"
    echo $signer | Out-File $HOME/.ssh/allowed_signers -Append
}

switch_git_user
