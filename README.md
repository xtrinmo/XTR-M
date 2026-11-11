# XTR-M - Open Source Desktop Launcher for Android - Phone + USB-C Hub = PC

XTR-M is an open-source desktop-style launcher for Android phones. **No root required.**

## Features
- Floating desktop windows and taskbar
- Docs, Sheets, Calendar, Email and Notes
- Browser, games launcher, expense tracking and KeyMapper UI
- Android-native keyboard and pointer input

## Build steps
```sh
flutter pub get
flutter build apk --release
```

# XTR-M PRO MAX — v1 beta14

Resource monitoring reads Android memory, CPU, battery, storage and network counters and displays N/A when unavailable. Game Booster only manages XTR-M windows/cache and cannot stop other apps.

# XTR-M PRO MAX — v1 beta14

Flutter desktop launcher with floating app windows, local Hive productivity apps and KeyMapper UI. Input is handled by Android/Flutter natively; KeyMapper only records mappings and does not inject touch events. Browser uses `webview_flutter`; wallpaper changes use a global notifier; Game Booster minimizes other app windows.

## Dependencies
See the exact dependency manifest in `pubspec.yaml`.

## Build APK
Requires Flutter SDK, Android SDK/toolchain, and network access to resolve packages:

```sh
flutter pub get
flutter build apk --release
```

## Build verification
Not verified in this environment: Flutter and Dart SDKs are unavailable. Run the build on Codemagic or another Flutter installation before treating this as a working release. The Codemagic workflow attempts Flutter Android scaffolding generation, restores XTR-M app sources, and runs launcher icon generation before analysis and release build. This environment has no Flutter SDK, so no local pub get, icon generation, analyzer, or APK build was run. Verify a successful Codemagic build before distributing. Validate plugin integration and app behavior on a real device.

## Phone-only GitHub + Codemagic build
1. In GitHub mobile app or browser, create a private repository.
2. Upload the complete project directory, preserving paths, using GitHub's web upload (or an Android Git client). Commit `pubspec.yaml`, `lib/`, `android/`, and `README.md`.
3. Sign in to Codemagic, connect GitHub and authorize that repository.
4. Add an Android workflow; use the Flutter stable channel and set the build command to `flutter pub get && flutter build apk --release`.
5. Enable APK artifact collection at `build/app/outputs/flutter-apk/*.apk`; run the workflow and download the artifact from the completed build.
6. For Play Store or trusted distribution, configure Android signing credentials in Codemagic; never commit keystores or passwords to the repository.

## Real-phone checks still required
- Resolve dependencies and perform a clean release build; verify webview_flutter plugin setup and HTTPS/network behavior.
- Test webview Back/Forward, tab state, URL entry, and error presentation on Android versions in scope.
- Test wallpaper switching persistence across app relaunch.
- Open several windows and verify Game Booster minimizes every non-game window.
- Test KeyMapper key capture with physical Bluetooth/USB keyboard; verify presets, custom mapping persistence, and touch-only phone behavior.
- Validate Hive persistence, keyboard visibility, window sizing/touch interactions, memory/performance, and release APK installation on target devices.
- KeyMapper does not inject taps/swipes into games; OS/root-level mapping is explicitly outside this app implementation.


## Beta9 resource management
Taskbar and Settings resource monitor data comes from Android platform APIs and uses `N/A` if a metric is unavailable. Free RAM below 1 GB triggers Lite Mode and minimizes an old XTR-M window; under 500 MB free storage offers Hive compaction and Flutter image cache clearing. Game Booster minimizes XTR-M windows, clears its image cache and requests a Dart GC event. Android does not permit this app to kill unrelated apps, and GC/memory reclamation is best-effort.


## Beta9: real device metrics and low-memory management
The taskbar and Settings resource monitor request memory, CPU, battery/temperature, filesystem capacity and total network-byte rate from Android. Unsupported metrics display `N/A`; throughput is total device RX+TX, not a per-interface Ethernet/Wi-Fi split. At under 1 GiB available RAM, Lite Mode is enabled and an older visible XTR-M window is minimized. At under 500 MiB filesystem space, the monitor offers Hive compaction and Flutter image-cache clearing. Game Booster minimizes non-game XTR-M windows, clears image caches and requests a fresh metrics sample; it cannot terminate other apps. Flutter exposes no supported imperative Dart-GC API, so GC remains runtime-managed.


## Beta11 Resource Management
Open Settings → Resource Management. Configure warning percentages, critical RAM, CPU alert, window limits, automation toggles, sleep timer and refresh interval. Profiles and slider selections persist in Hive box `resource_settings`; changing a value switches the active profile to Custom. Reset to Default restores Balanced defaults. To verify: set Low RAM Warning to 30%, save, open windows until Android-reported free RAM falls to the threshold, and confirm the warning. Actual RAM pressure varies by device; a test may require memory-intensive other apps or a device/emulator with constrained memory.


## Beta11: configurable resource management
Settings → Resource Management provides persisted percentage thresholds, CPU warning threshold, Lite/Normal window caps, automation toggles, background sleep choice, polling interval and Battery Saver/Balanced/Performance profiles. User edits switch the selected profile to Custom; Reset to Default restores Balanced. Critical RAM is constrained below the low-RAM threshold. Test by setting Low RAM Warning to 30%, saving, then applying enough system memory pressure to reduce reported free RAM to that percentage; device-wide pressure varies, so opening launcher windows alone may not trigger it.

## Logo
The supplied XTR-M image is stored at `assets/icon/logo.png` and configured for launcher icon generation, splash, desktop header and Settings About.
