function Install-Keybase {
    if (!(Invoke-Step-Entry)) { return }

    # Write-Output "**** assert failed. installing keybase *******"
    winget install -e --id Keybase.Keybase
    Invoke-Refresh-Path
    
    Write-Output @"
    Login to keybase and then activate Explorer integration
    by clicking on Files, Explorer Integration.
    When you have done this, press enter to continue...
"@

    Read-Host

    Invoke-Step-Exit
}
