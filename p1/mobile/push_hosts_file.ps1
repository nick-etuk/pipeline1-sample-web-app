function push_hosts_file {
    $script_dir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    adb root
    adb -s emulator-$ANDROID_EMULATOR_PORT remount
    adb reboot

    # remount after reboot
    adb root
    adb -s emulator-$ANDROID_EMULATOR_PORT remount
    adb -s emulator-$ANDROID_EMULATOR_PORT push "$script_dir/android-hosts.txt" /system/etc/hosts
    # cd C:\Users\Nick\.pipeline1\remote_projects\pipeline1-sample-web-app\p1\mobile
    # adb -s emulator-$ANDROID_EMULATOR_PORT push "android-hosts.txt" /system/etc/hosts
}
push_hosts_file

