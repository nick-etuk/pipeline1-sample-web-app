#!/usr/bin/env bash

open_ide() {
    local ide
    ide="$1_$MY_OS"

    case "$ide" in
        android_macos)
            open -a "/Applications/Android Studio.app" "$REPO_DIR_UNIX/nhsapp-android"
            ;;
        android_ubuntu)
            studio64.exe "$REPO_DIR_WIN/nhsapp-android"
            ;;
        bdd_macos)
            open -na "IntelliJ IDEA CE.app" "$REPO_DIR_UNIX/nhsapp/bddtests"
            ;;
        ios_macos)
            xed "$REPO_DIR_UNIX/nhsapp-ios"
            ;;        
        web_macos )
            open -na "Visual Studio Code.app" "$REPO_DIR_UNIX/nhsapp/web"
            ;;
        web_ubuntu)
            code "$REPO_DIR_UNIX/nhsapp/web"
            ;;
        xit_macos)
            rider "$REPO_DIR_UNIX/nhsapp/xamarinintegrationtests/NHSOnline.IntegrationTests.sln"
            ;;
        *)
            error "Unknown IDE: $ide"
    esac
    sleep 5
}

open_ide "$1"