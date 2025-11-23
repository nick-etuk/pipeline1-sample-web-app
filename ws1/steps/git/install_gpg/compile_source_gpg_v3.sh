#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

compile_source_gpg_v3() {
    local package_name
    local package_title
    local package_version
    local tmp_dir
    
    tmp_dir=$1
    package_name="gnupg"
    package_title="gnupg"
    package_version="$GNUPG_VERSION"
    source_base_url="https://www.gnupg.org/ftp/gcrypt/$package_title"

    compile_source "$tmp_dir" "$package_name" "$package_title" "$package_version" "$source_base_url"
}
