function PushHostsFile {
    adb root
    adb -s emulator-$ANDROID_EMULATOR_PORT remount
    adb -s emulator-$ANDROID_EMULATOR_PORT push "$WS_ROOT_WIN/lib/conf/android-hosts.txt" /system/etc/hosts
}
