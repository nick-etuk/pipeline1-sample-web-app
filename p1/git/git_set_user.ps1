param (
    [Parameter(Position=0)]
    [string]$user_type
)

function set_git_user($user_type) {
    # Don't do this. Set the git user email and signing key locally for each repo instead.
    $current_email = (git config user.email)
    switch($user_type) {
        'nhs' {
           $email = 'nick_etuk2@nhs.net'
           $public_key_file = "$HOME\.ssh\id_ed25519.pub"
        }
        'hotmail' {
            $email = 'nick_etuk@hotmail.com'
            $public_key_file = "$HOME\.ssh\id_ed25519_nick-etuk.pub"
        }
        'yahoo' {
            $email = 'netuk3@yahoo.co.uk'
            $public_key_file = "$HOME\.ssh\id_ed25519_nick-etuk.pub"
        }
        default {
            WriteWarn "Invalid git email: $current_email"
            return
        }
    }

    git config user.email $email
    git config user.signingkey $public_key_file
}

function gobal_ssh_config {
    git config --global gpg.format ssh
    # git config --global core.sshCommand "'C:\Windows\System32\OpenSSH\ssh.exe'"
    git config --global core.sshCommand "`'$((Get-Command ssh.exe).Source)`'"
    git config --global gpg.ssh.program (Get-Command ssh-keygen.exe).Source

    git config --global commit.gpgsign true
    git config --global tag.gpgsign true


    git config --global gpg.ssh.allowedSignersFile $HOME/.ssh/allowed_signers

}

set_git_user $user_type
