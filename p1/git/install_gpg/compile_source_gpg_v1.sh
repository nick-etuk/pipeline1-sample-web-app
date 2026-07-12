#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1091

install_gpg_source_v1() {
    local tmp_dir

    GPG_VERSION=2.4.8
    LIBGPG_ERROR_VERSION=1.56
    LIBKSBA_VERSION=1.6.7
    # tmp_dir=$(mktemp -d)
    tmp_dir=$1
    # cd "$tmp_dir" || exit 1
    # echo "Working in temporary directory: $tmp_dir"

    # script_dir=$(dirname "$0")
    # source "$script_dir/install_libksba.sh"

    sudo apt-get install -y build-essential bzip2 libassuan-dev libgcrypt20-dev libgpg-error-dev libksba-dev libnpth0-dev
    
    wget "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2"

    wget https://www.gnupg.org/signature_key.asc -O - | gpg --import -
    wget "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2.sig" -O - | gpg --verify - "gnupg-$GPG_VERSION.tar.bz2"

    signers=('Werner Koch' 'Niibe Yutaka' 'Alexander Kulbartsch')
    verified='false'
    for signer in "${signers[@]}"; do
        if gpg --verify "gnupg-$GPG_VERSION.tar.bz2.sig" "gnupg-$GPG_VERSION.tar.bz2" 2>&1 | grep -q "Good signature from \"$signer\""; then
            echo "Signature verified from $signer"
            verified='true'
            break
        fi
    done
    if [ "$verified" = 'false' ]; then
        echo "Failed to verify the signature of gnupg-$GPG_VERSION.tar.bz2 in $tmp_dir"
        read -r -p "Do you want to continue? (y/n): " choice
        if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
            echo "Exiting."
            exit 1
        fi
    fi

    tar xf "gnupg-$GPG_VERSION.tar.bz2"
    cd "gnupg-$GPG_VERSION" || exit 1
    if [ ! -d /usr/local/lib/pkgconfig/ ]; then
        echo 'Creating /usr/local/lib/pkgconfig/'
        sudo mkdir -p /usr/local/lib/pkgconfig/
        sudo chmod o+rx /usr/local/lib/pkgconfig/
    fi
    ./configure --prefix=/usr/local > configure.log 2>&1
    
    # Check configure results and install any missing dependencies
    if [ $? -ne 0 ]; then
        echo "Configure failed. Checking for missing dependencies..."
        cat configure.log
        
        # Check for common missing libraries in the configure log
        if grep -q "libgpg-error" configure.log; then
            echo "Installing libgpg-error..."
            sudo apt-get install -y libgpg-error-dev
        fi
        if grep -q "libassuan" configure.log; then
            echo "Installing libassuan..."
            sudo apt-get install -y libassuan-dev
        fi
        if grep -q "libksba" configure.log; then
            echo "libksba should already be insalled"
            exit 1
            # install_libksba "$tmp_dir"
        fi
        if grep -q "libgcrypt" configure.log; then
            echo "Installing libgcrypt..."
            sudo apt-get install -y libgcrypt20-dev
        fi
        if grep -q "libnpth" configure.log; then
            echo "Installing libnpth..."
            sudo apt-get install -y libnpth0-dev
        fi
        
        # Retry configure after installing missing dependencies
        echo "Retrying configure..."
        ./configure --prefix=/usr/local
        if [ $? -ne 0 ]; then
            echo "Configure still failed. Please check the output above."
            exit 1
        fi
    fi
    exit 0 # debugging line to be removed later
    # Build and install
    echo "Building GnuPG..."
    make -j"$(nproc)"
    if [ $? -ne 0 ]; then
        echo "Build failed. Please check the output above."
        exit 1
    fi
    
    echo "Installing GnuPG..."
    sudo make install
    if [ $? -ne 0 ]; then
        echo "Installation failed. Please check the output above."
        exit 1
    fi
    
    # Update library cache
    sudo ldconfig
    
    echo "GnuPG $GPG_VERSION installed successfully to /usr/local"
    /usr/local/bin/gpg --version

}