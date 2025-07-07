#!/usr/bin/env bash

function wait_for_emulator_android {
    info "Waiting for android emulator to start"
    while ! adb -s emulator-"$ANDROID_EMULATOR_PORT" shell echo 'I am alive'; do
        sleep 5
        echo -n "."
    done
    echo ""
}

function start_emulator_android {
    # DEFAULT_DEVICE="Pixel_8a_API_35"
    DEFAULT_DEVICE="Pixel_5_API_34"
    # emulator -list-avds | grep "$DEFAULT_DEVICE" || create_android_emulator

    emulator -avd $DEFAULT_DEVICE -no-snapshot-load -writable-system
}

function wait_for_emulator_ios {
    info "Waiting for ios emulator to start"
    while ! ps aux | grep -v grep | grep -iq 'Simulator.app'; do
        sleep 5
        echo -n "."
    done
    echo ""
}

function start_emulator_ios {
    open -a Simulator.app
}

function start_emulator {
    local platform

    platform='android'
    [ "$MY_OS" = 'macos' ] && platform='ios'

    "start_emulator_$platform"
    "wait_for_emulator_$platform"
}