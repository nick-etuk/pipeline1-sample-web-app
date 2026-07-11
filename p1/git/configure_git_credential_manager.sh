#!/usr/bin/env bash

#!/usr/bin/env bash

find_gcm() {
    local likely_paths
    local grand_parent_dir
    local path
    local exe_path
    
    if [ -z "${GIT_PATH_WIN+set}" ]; then
        warn "Warning: GIT_PATH_WIN is not set. Cannot search for git-credential-manager"
        return
    fi
    
    likely_paths=(
        "$GIT_PATH_WIN\mingw64\bin\git-credential-manager.exe"
        "$GIT_PATH_WIN\mingw64\libexec\git-core\git-credential-manager.exe"
        "$GIT_PATH_WIN\mingw64\libexec\git-core\git-credential-manager-core.exe"
        )

    for path in "${likely_paths[@]}"; do
        if [ -f "$path" ]; then
            info "GCM found in likely path $path"
            GCM_PATH="$(dirname "$path")"
            set_context 'gcm_path' "$GCM_PATH"
            break
        fi
    done

    grand_parent_dir=$(dirname "$(dirname "$GIT_PATH_WIN")")
    info "Searching for git-credential-manager.exe in $grand_parent_dir"

    exe_path=$(find "$grand_parent_dir" -name 'git-credential-manager.exe')
    if [ -n "$exe_path" ]; then
        GCM_PATH="$(dirname "$exe_path")"
        set_context 'gcm_path' "$GCM_PATH"
    fi
}

configure_git_credential_manager() {
    local gcm_path

    [ git config --global --list | grep -iq 'git-credential-manager' ] && return 0
    
    find_gcm
    gcm_path=$(get_context 'gcm_path')
    if [ -z "$gcm_path" ]; then
        warn "Context variable gcm_path is not set. Cannot configure git credential manager"
        return
    fi
    
    git config --global credential.helper \""$gcm_path"\"
    # git config --global credential.helper "/mnt/f/app/Git/mingw64/bin/git-credential-manager.exe"
    # git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    
    # git config --global user.email "nick_etuk@hotmail.com"
    # git config --global user.name "Nick Etuk"
}

configure_git_credential_manager
