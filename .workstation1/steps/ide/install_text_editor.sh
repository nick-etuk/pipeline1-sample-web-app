#!/usr/bin/env bash

function install_text_editor {
    case "$MY_OS" in
        macos)
            # todo: install coteditor
            ln -s /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/cot
            ;;
        ubuntu)
            # todo: install nano if needed
            ;;
        wsl)
            # todo: install notepad ++
            ;;
        *)
            error "Unnown OS $MY_OS"
    esac
}

install_text_editor