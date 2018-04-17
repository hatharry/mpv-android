mkdir -p /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/is/xyz/mpv/
mkdir -p /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/armeabi-v7a/
#mkdir -p /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/arm64-v8a/
cp /mnt/c/Users/luke/Documents/GitHub/mpv-android/app/build/intermediates/classes/debug/is/xyz/mpv/* /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/is/xyz/mpv/
cp /mnt/c/Users/luke/Documents/GitHub/mpv-android/app/build/tmp/kotlin-classes/debug/is/xyz/mpv/* /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/is/xyz/mpv/
cp /mnt/c/Users/luke/Documents/GitHub/mpv-android/app/src/main/libs/armeabi-v7a/* /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/armeabi-v7a/
#cp /mnt/c/Users/luke/Documents/GitHub/mpv-android/app/src/main/libs/arm64-v8a/* /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/arm64-v8a/
rm -f /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv_arm.jar
pushd /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv
zip -r -9 /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv_arm.jar .
popd
rm -rf /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/armeabi-v7a
#rm -rf /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/arm64-v8a
mkdir -p /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/x86/
cp /mnt/c/Users/luke/Documents/GitHub/mpv-android/app/src/main/libs/x86/* /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv/lib/x86/
rm -f /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv_x86.jar
pushd /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv
zip -r -9 /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv_x86.jar .
popd
rm -rf /mnt/c/Users/luke/Documents/GitHub/emby-android-dev/libs/libmpv