#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail

install_gpg_source_v2() {
    local tmp_dir

    if [[ -z "${GPG_VERSION:-}" ]]; then
        echo "GPG_VERSION is not set. Export GPG_VERSION first (e.g. export GPG_VERSION=2.4.4)." >&2
        exit 1
    fi

    echo "[INFO] Installing base build dependencies via apt-get..."
    sudo apt-get update -y
    sudo apt-get install -y \
        build-essential bzip2 wget gnupg dirmngr \
        libassuan-dev libgcrypt20-dev libgpg-error-dev libksba-dev libnpth0-dev

    tmp_dir=$(mktemp -d)
    echo "[INFO] Working in temporary directory: $tmp_dir"
    cd "$tmp_dir" || exit 1
    echo "[INFO] Downloading gnupg-$GPG_VERSION source archive..."
    wget -q "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2"

    echo "[INFO] Importing GnuPG signature key..."
    wget -q https://www.gnupg.org/signature_key.asc -O - | gpg --import -
    echo "[INFO] Downloading signature file..."
    wget -q "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2.sig"

    echo "[INFO] Verifying archive signature (initial check)..."
    gpg --verify "gnupg-$GPG_VERSION.tar.bz2.sig" "gnupg-$GPG_VERSION.tar.bz2" || true

    local signers=("Werner Koch" "Niibe Yutaka" "Alexander Kulbartsch")
    local verified=false
    for signer in "${signers[@]}"; do
        if gpg --verify "gnupg-$GPG_VERSION.tar.bz2.sig" "gnupg-$GPG_VERSION.tar.bz2" 2>&1 | grep -q "Good signature from \"$signer\""; then
            echo "[INFO] Signature verified from $signer"
            verified=true
            break
        fi
    done
    if [[ "$verified" == false ]]; then
        echo "[WARN] Failed to match a trusted signer for gnupg-$GPG_VERSION.tar.bz2 in $tmp_dir" >&2
        read -r -p "Do you want to continue despite unverifiable signature? (y/N): " choice
        if [[ "${choice:-N}" != "y" && "${choice:-N}" != "Y" ]]; then
            echo "[INFO] Exiting due to signature verification failure." >&2
            exit 1
        fi
    fi

    echo "[INFO] Extracting source..."
    tar xf "gnupg-$GPG_VERSION.tar.bz2"
    cd "gnupg-$GPG_VERSION" || exit 1

    # Ensure pkgconfig directory exists (previous script only chmod'd it if absent)
    if [[ ! -d /usr/local/lib/pkgconfig ]]; then
        echo "[INFO] Creating /usr/local/lib/pkgconfig"
        sudo mkdir -p /usr/local/lib/pkgconfig
        sudo chmod 755 /usr/local/lib/pkgconfig
    fi

    echo "[INFO] Running initial ./configure ..."
    if ! ./configure --prefix=/usr/local > configure.log 2>&1; then
        echo "[WARN] Initial configure exited with non-zero status; will analyze missing items." >&2
    fi

    echo "[INFO] Scanning configure.log for missing libraries..."
    # Collect lines like: checking for LIBXYZ ... no
    mapfile -t missing_checks < <(grep -E 'checking for .*\.\.\. no' configure.log || true)

    if (( ${#missing_checks[@]} )); then
        echo "[INFO] Found potential missing items:"
        printf '  %s\n' "${missing_checks[@]}"
    else
        echo "[INFO] No obvious missing libraries detected in configure.log."
    fi

    # Map common substrings to Debian packages
    declare -A pkg_map=(
        [zlib]=zlib1g-dev
        [bz2]=libbz2-dev
        [bzip2]=libbz2-dev
        [readline]=libreadline-dev
        [sqlite3]=libsqlite3-dev
        [gettext]=gettext
        [iconv]=libc6-dev # iconv in glibc
        [curl]=libcurl4-openssl-dev
        [npth]=libnpth0-dev
        [gpg-error]=libgpg-error-dev
        [gcrypt]=libgcrypt20-dev
        [assuan]=libassuan-dev
        [ksba]=libksba-dev
    )

    declare -A to_install=()
    for line in "${missing_checks[@]}"; do
        # Extract token after 'checking for ' up to '... no'
        lib_token=$(sed -E 's/.*checking for ([^\.]+)\.\.\. no.*/\1/' <<<"$line" | tr ' ' '-')
        for key in "${!pkg_map[@]}"; do
            if grep -qi "$key" <<<"$lib_token"; then
                to_install[$key]="${pkg_map[$key]}"
            fi
        done
    done

    if (( ${#to_install[@]} )); then
        echo "[INFO] Attempting to install missing packages:"
        for k in "${!to_install[@]}"; do
            echo "  -> ${to_install[$k]} (matched: $k)"
        done
        sudo apt-get install -y "${to_install[@]}"
        echo "[INFO] Re-running ./configure after installing missing packages..."
        if ! ./configure --prefix=/usr/local > configure.log 2>&1; then
            echo "[ERROR] configure still failing after attempting dependency installation. Check configure.log." >&2
            tail -n 40 configure.log >&2 || true
            exit 1
        fi
    else
        echo "[INFO] No additional packages mapped for installation."
    fi

    echo "[INFO] configure completed successfully. Review configure.log for details."
    echo "[NEXT] You may now run: make -j$(nproc) && sudo make install"
}

install_gpg_source