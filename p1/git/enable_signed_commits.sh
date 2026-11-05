#!/usr/bin/env bash
# shellcheck disable=SC1091

script_dir=$(dirname "$(realpath "$0")")
    
source "$script_dir/enable_signed_commits_ssh.sh"
source "$script_dir/enable_signed_commits_gpg.sh"

enable_signed_commits_ssh