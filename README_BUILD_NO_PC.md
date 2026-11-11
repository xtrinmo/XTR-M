# XTR-M — Build an APK using only your phone

## 1. Upload the project to GitHub
1. Open GitHub in your phone browser/app and sign in; create a repository (Private is recommended).
2. Open the repository and choose **Add file → Upload files**. Select the XTR-M project files and preserve paths: `lib/`, `android/`, `pubspec.yaml`, and `codemagic.yaml` must remain at the repository root.
3. Commit the upload. If the mobile site cannot upload folders, use an Android Git client or upload files in batches while preserving directories. Never commit signing keys or passwords.

## 2. Connect Codemagic
1. Open [Codemagic](https://codemagic.io/) in your phone browser; create/sign in to an account.
2. Choose **Add application → GitHub**, authorize Codemagic, and select the XTR-M repository.
3. Use the committed `codemagic.yaml`, select workflow `xtrm-android-release`, and start the build.
4. The workflow runs `flutter pub get`, `flutter analyze`, and `flutter build apk --release`. Consider it successful only if all three pass and the APK appears under Artifacts.

## 3. Download the APK
1. Open the completed build in Codemagic and select **Artifacts → app-release.apk**.
2. Download it; it should appear in the phone's Downloads folder.

## 4. Install on Android
1. Tap `app-release.apk` in Downloads/Files.
2. If blocked, open the system prompt and enable **Allow from this source / Install unknown apps** for the downloading browser or file manager.
3. Return to the APK, tap **Install**, then open XTR-M. Optionally disable the source permission again afterward.

## Important caveats
- This repository now has an app manifest at `android/app/src/main/AndroidManifest.xml`, but its Android project is hand-assembled and still lacks Gradle wrapper scripts/JAR and some standard Flutter-generated Android scaffolding. The cloud build may fail until standard scaffolding is generated/merged. Do not assume it builds before Codemagic reports success.
- Configure signing credentials securely in Codemagic if needed. Never upload passwords or private keystores to GitHub.
- A cloud build does not replace testing on the target Android device.
