function open_ide {
    Param (
        [Parameter(Position=0)]
        $IDE,
        [Parameter(Position=1)]
        $location
    )
    switch ($IDE) {
        android_studio { 
            Start-Process studio64.exe "$location"
        }
        intellij { 
            Start-Process idea64.exe "$location"
        }
        vscode { 
            Start-Process code.exe "$location"
        }
    }
}