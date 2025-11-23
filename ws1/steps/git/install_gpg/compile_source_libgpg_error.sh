#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

compile_source_libgpg_error() {
    local package_name
    local package_title
    local package_version
    local tmp_dir
    
    tmp_dir=$1
    package_name="libgpg-error-dev"
    package_title="libgpg-error"
    package_version="$LIBGPG_ERROR_VERSION"
    source_base_url="https://www.gnupg.org/ftp/gcrypt/$package_title"

    compile_source "$tmp_dir" "$package_name" "$package_title" "$package_version" "$source_base_url"
}
