function wait_for_emulator {
    while ($true) {
        $output = adb shell getprop sys.boot_completed 2>&1
        if ($output -match "1") {
            break
        }
        Start-Sleep -Seconds 1
    }
}

function start_emulator {
    # No need to support ios emulator in Windows

    # Start-Process pwsh -ArgumentList "-NoExit", "-c", "`$Host.UI.RawUI.BackgroundColor = 'DarkBlue'; Clear-Host; $PSScriptroot\start_emulator.ps1"
    
    emulator -avd $ANDROID_DEFAULT_DEVICE -no-snapshot-load -writable-system
    wait_for_emulator
}
start_emulator