#!/usr/bin/env bash

case "$MY_OS" in     
    macos)
        open -na "IntelliJ IDEA CE.app" "$REPO_DIR_UNIX/nhsapp/bddtests"
        ;;
    wsl)
        idea64.exe "$REPO_DIR_UNIX\nhsapp\bddtests"
        ;;
    *)
        error "Unknown OS: $MY_OS"
esac