function Start-Emulator {
    # No need to support ios emulator in Windows

    # Start-Process pwsh -ArgumentList "-NoExit", "-c", "`$Host.UI.RawUI.BackgroundColor = 'DarkBlue'; Clear-Host; $PSScriptroot\start-emulator.ps1"
    $ANDROID_ANDROID_DEFAULT_DEVICE="Pixel_5_API_34"
    emulator -avd $ANDROID_ANDROID_DEFAULT_DEVICE -no-snapshot-load -writable-system
    Wait-For-Emulator
}
