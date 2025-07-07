#!/usr/bin/env bash

function open_vscode {
    case "$MY_OS" in     
        macos)
            open -na "Visual Studio Code.app" "$REPO_DIR_UNIX/nhsapp/web"
            ;;
        wsl)
            code "$REPO_DIR_UNIX/nhsapp/web"
            ;;
        *)
            error "Unknown OS: $MY_OS"
    esac
}

open_vscode