#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

compile_source() {
    local package_name
    local package_title
    local package_version
    local tmp_dir
    local apt_version

    tmp_dir=$1
    package_name=$2
    package_title=$3
    package_version=$4
    source_base_url=$5


    source_archive="$package_title-$package_version.tar.bz2"
    source_url="$source_base_url/$source_archive"

    echo "Installing $package_title..."
    echo "Package: $package_name"
    echo "Required version: $package_version"
    echo "URL: $source_url"
    echo "Working directory: $tmp_dir"

    echo "Installing $package_title..."
    if [ ! -d "$tmp_dir" ]; then
        tmp_dir=$(mktemp -d)
        echo "Created new temporary directory: $tmp_dir"
    fi
    cd "$tmp_dir" || exit 1

    apt_version=$(apt-cache madison "$package_name" | head -1 | awk '{print $3}')
    # if [[ "$(printf '%s\n' "$package_version" "$apt_version" | sort -V | head -n1)" == "$package_version" ]]; then
    if ! [[ "$apt_version" < "$package_version" ]]; then
        echo "Installing with $package_title with package manager..."
        sudo apt-get install -y "$package_name"
    else
        echo "Package manger version of $package_name ($apt_version) is less than required ($package_version)."
        echo "Installing required version of $package_name from source..."
        
        [ ! -f "$source_archive" ] && wget "$source_url"
        
        [ ! -d "$package_title-$package_version" ] && tar xf "$source_archive"
    
        cd "$package_title-$package_version" || exit 1

        if [ ! -d /usr/local/lib/pkgconfig/ ]; then
            echo 'Creating /usr/local/lib/pkgconfig/'
            sudo mkdir -p /usr/local/lib/pkgconfig/
            sudo chmod o+rx /usr/local/lib/pkgconfig/
        fi

        # if ! ./configure --prefix=/usr/local > "configure-$package_title.log" 2>&1; then
        if ! ./configure > "configure-$package_title.log" 2>&1; then
            more "configure-$package_title.log"
            echo "Configure failed. Please install the missing dependencies and re-run the installation."
            return 1
        fi

        # make -j"$(nproc)"
        make
        sudo make install
        # cd ..
        sudo ldconfig
        echo "$package_title successfully installed from source."
    fi
}
