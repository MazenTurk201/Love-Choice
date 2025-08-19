flutter build apk --release --obfuscate --split-debug-info=build/debug_info --target-platform android-arm64
adb install build\app\outputs\flutter-apk\app-release.apk