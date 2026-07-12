#!/usr/bin/env bash

function add_android_paths {
    local paths_to_add

    paths_to_add=(
        "$HOME/Library/Android/sdk/emulator"
        "$HOME/Library/Android/sdk/platform-tools"
    )

    for new_path in "${paths_to_add[@]}"; do
        if [[ ! $PATH == *$new_path* ]]; then
            export PATH="$PATH:$new_path"
            echo "Added $new_path to path"
        fi
    done
}
add_android_paths
