#!/usr/bin/env bash

function create_android_device {
    if ! emulator -list-avds | grep -q "$ANDROID_DEFAULT_DEVICE"; then
        echo "Creating android emulator $ANDROID_DEFAULT_DEVICE"
        avdmanager create avd -n "$ANDROID_DEFAULT_DEVICE" -k "system-images;android-34;google_apis;x86_64" --force
    else
        echo "Android emulator $ANDROID_DEFAULT_DEVICE already exists"
    fi
}
create_android_device
