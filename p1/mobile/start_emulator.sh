#!/usr/bin/env bash

function wait_for_emulator_android {
    info "Waiting for android emulator to start"
    while ! adb -s emulator-"$ANDROID_EMULATOR_PORT" shell echo 'I am alive'; do
        sleep 5
        echo -n "."
    done
    echo ""
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

function start_emulator_android {
    emulator -avd $ANDROID_DEFAULT_DEVICE -no-snapshot-load -writable-system
}

function start_emulator {
    local platform

    platform="$1"

    "start_emulator_$platform"
    "wait_for_emulator_$platform"
}
start_emulator "$1"