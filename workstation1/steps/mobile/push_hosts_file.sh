#!/usr/bin/env bash
function push_hosts_file {

    adb root
    # adb -s emulator-$port shell mount -o rw,remount /system
    adb -s "emulator-$ANDROID_EMULATOR_PORT" remount
    adb -s "emulator-$ANDROID_EMULATOR_PORT" push "$WS_ROOT_UNIX/core/lib/conf/android-hosts.txt" /system/etc/hosts
    # adb -s adb-R8YX30F294R-UBYHYZ._adb-tls-connect._tcp push "$WS_ROOT_UNIX/core/lib/conf/android-hosts.txt" /system/etc/hosts

    # info "New hosts file:"
    # adb -s emulator-$ANDROID_EMULATOR_PORT shell cat /system/etc/hosts

}
