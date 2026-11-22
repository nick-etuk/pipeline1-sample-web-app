param (
    [Parameter(Position=0)]
    [string]$user_type
)

function set_git_user($user_type) {
    $current_email = (git config user.email)
    switch($user_type) {
        'nhs' {
           $git_email = 'nick.etuk2@nhs.net'
           $ssh_key = "$HOME\.ssh\id_ed25519_nhs.pub"
        }
        'hotmail' {
            $git_email = 'nick_etuk@hotmail.com'
            $ssh_key = "$HOME\.ssh\id_ed25519_nick_etuk.pub"
        }
        'yahoo' {
            $git_email = 'netuk3@yahoo.co.uk'
            $ssh_key = "$HOME\.ssh\id_ed25519_nick_etuk.pub"
        }
        default {
            WriteWarn "Invalid git email: $current_email"
            return
        }
    }

    git config user.email $git_email
    git config user.signingkey "$ssh_key.pub"
}

function global_ssh_config_for_signing {
    git config --global gpg.format ssh
    # git config --global core.sshCommand "'C:\Windows\System32\OpenSSH\ssh.exe'"
    git config --global core.sshCommand "`'$((Get-Command ssh.exe).Source)`'"
    git config --global gpg.ssh.program (Get-Command ssh-keygen.exe).Source

    git config --global commit.gpgsign true
    git config --global tag.gpgsign true


    git config --global gpg.ssh.allowedSignersFile "$HOME/.ssh/allowed_signers"

}

set_git_user $user_type
