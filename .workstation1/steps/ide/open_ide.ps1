function Open-IDE {
    Param (
        [Parameter(Position=0)]
        $Stage
    )
    switch ($Stage) {
        android { 
            Start-Process studio64.exe "$REPO_DIR\nhsapp-android"
        }
        bdd { 
            Start-Process idea64.exe "$REPO_DIR\nhsapp\bddtests"
        }
        web { 
            Start-Process code.exe "//wsl.localhost/Ubuntu/home/$WSL_USER/repos/nhsapp/web"
        }
    }
}