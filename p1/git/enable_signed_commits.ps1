function enable_signed_commits {
    # Can this just be the filename instead of the file content?
    git config --global user.signingkey (Get-Content $HOME\.ssh\id_ed25519.pub)
    git config --global gpg.format ssh
    git config --global gpg.ssh.program (Get-Command ssh-keygen.exe).Source
    git config --global core.sshCommand (Get-Command ssh.exe).Source

    git config --global commit.gpgsign true
    git config --global tag.gpgsign true


    git config --global user.email nick.etuk2@nhs.net
    git config --global gpg.ssh.allowedSignersFile $HOME/.ssh/allowed_signers

    $email = (git config user.email)
    $key = (Get-Content $HOME/.ssh/id_ed25519.pub)
    $signer = "$email $key"
    echo $signer | Out-File $HOME/.ssh/allowed_signers -Append
}
