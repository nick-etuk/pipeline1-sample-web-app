function Get-Personal-Access-Token {
    if (!(Invoke-Step-Entry)) { return }

    Show-Help Get-Personal-Access-Token
    $PAT = Read-Host "Personal Access Token:"
    if ($PAT) {
        $PAT | Out-File -FilePath "$WORKING_DIR\.pat"
    
    }

    Invoke-Step-Exit
}
