#!/usr/bin/env bash

mkdir -p ~/.nhsonline/secrets
if [ ! -d /mnt/c/provisioning/working/keybase ]; then
    warn "Keybase directory not found at /mnt/c/provisioning/working/keybase"
    return
fi
cp /mnt/c/provisioning/working/keybase/* ~/.nhsonline/secrets
