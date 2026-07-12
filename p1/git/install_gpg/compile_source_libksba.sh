#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

compile_source_libksba() {
    local package_name
    local package_title
    local package_version
    local tmp_dir
    
    tmp_dir=$1
    package_name="libksba-dev"
    package_title="libksba"
    package_version="$LIBKSBA_VERSION"
    source_base_url="https://www.gnupg.org/ftp/gcrypt/libksba"

    compile_source "$tmp_dir" "$package_name" "$package_title" "$package_version" "$source_base_url"
}
