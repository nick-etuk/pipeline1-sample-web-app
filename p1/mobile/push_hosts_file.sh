#!/usr/bin/env bash
function push_hosts_file {
    local script_dir

    script_dir="$(dirname "$(realpath "$0")")"

    adb root
    # adb -s emulator-$port shell mount -o rw,remount /system
    adb -s "emulator-$ANDROID_EMULATOR_PORT" remount
    adb reboot
    # todo: call wait_for_emulator andoid here. Add wait_for_emulator to libs

    # remount after reboot
    adb root
    adb -s emulator-$ANDROID_EMULATOR_PORT remount
    adb -s "emulator-$ANDROID_EMULATOR_PORT" push "$script_dir/android-hosts.txt" /system/etc/hosts
    # adb -s adb-R8YX30F294R-UBYHYZ._adb-tls-connect._tcp push "$P1_ROOT_UNIX/core/lib/conf/android-hosts.txt" /system/etc/hosts

    # info "New hosts file:"
    # adb -s emulator-$ANDROID_EMULATOR_PORT shell cat /system/etc/hosts
    # | grep -q web.local.bitraft.io

}
push_hosts_file
