# Tembea Kenya

Tembea Kenya is a hiking application to enhance hiking experience and community.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup and Installation

<!-- Before starting with the installation, follow the stebs to setup your mobile device.

- Open settings on your mobile
- Open 'Systems'
-  -->

Clone the repository on your computer

Open the terminal and navigate to the repository folder.

All the necessary dependencies have been included in [pubspec.yaml](pubspec.yaml). To run the dependencies: run the following command in the terminal.

``` bash
flutter pub get
```

To build the app on Android, run the following command:

``` bash
flutter build apk
```

Alternatively, you could run the app on debug mode with the following command:

``` bash
flutter run
```

> The Application is configured to run with a Backend server. Check out the [Link to Backend API Server (Github)](https://github.com/raphaelkathambana/tembeakenyabackend) here.

## Project Structure

All the application code can be found on the ```/lib``` folder. Specific code for iOS and Android can be found in the ```/ios``` and ```/android``` folders respectively.

### File Structure

```css
📦 tembeakenya
├─ .gitignore
├─ .metadata
├─ README.md
├─ analysis_options.yaml
├─ android
│  ├─ .gitignore
│  ├─ app
│  │  ├─ build.gradle
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ app
│  │     │  │           └─ FlutterMultiDexApplication.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ codeclimbers
│  │     │  │        └─ tembeakenya
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable-hdpi
│  │     │     │  ├─ branding.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-mdpi
│  │     │     │  ├─ branding.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-v21
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-xhdpi
│  │     │     │  ├─ branding.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-xxhdpi
│  │     │     │  ├─ branding.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-xxxhdpi
│  │     │     │  ├─ branding.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values-night-v31
│  │     │     │  └─ styles.xml
│  │     │     ├─ values-night
│  │     │     │  └─ styles.xml
│  │     │     ├─ values-v31
│  │     │     │  └─ styles.xml
│  │     │     └─ values
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle.properties
│  ├─ gradle
│  │  └─ wrapper
│  │     └─ gradle-wrapper.properties
│  └─ settings.gradle
├─ devtools_options.yaml
├─ ios
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  ├─ BrandingImage.imageset
│  │  │  │  ├─ BrandingImage.png
│  │  │  │  ├─ BrandingImage@2x.png
│  │  │  │  ├─ BrandingImage@3x.png
│  │  │  │  └─ Contents.json
│  │  │  ├─ LaunchBackground.imageset
│  │  │  │  ├─ Contents.json
│  │  │  │  └─ background.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ assets
│  │  ├─ colors.dart
│  │  ├─ fonts
│  │  │  ├─ Montserrat-Bold.ttf
│  │  │  ├─ Montserrat-BoldItalic.ttf
│  │  │  ├─ Montserrat-Light.ttf
│  │  │  └─ Montserrat-LightItalic.ttf
│  │  └─ images
│  │     ├─ brand.jpg
│  │     ├─ defaultProfilePic.png
│  │     ├─ logo.png
│  │     ├─ mountbackground.png
│  │     ├─ mountbg.png
│  │     ├─ picOne.png
│  │     ├─ placeHolder.png
│  │     └─ profile.png
│  ├─ constants
│  │  ├─ constants.dart
│  │  ├─ image_operations.dart
│  │  └─ routes.dart
│  ├─ controllers
│  │  └─ auth_controller.dart
│  ├─ dummy_db.dart
│  ├─ main.dart
│  ├─ model
│  │  ├─ user.dart
│  │  └─ user.g.dart
│  ├─ navigations
│  │  ├─ community_nav_bar.dart
│  │  └─ nav_bar.dart
│  └─ views
│     ├─ change_password.dart
│     ├─ forgot_view.dart
│     ├─ group_detail_view.dart
│     ├─ group_view.dart
│     ├─ home_page.dart
│     ├─ login_view.dart
│     ├─ people_detail_view.dart
│     ├─ people_view.dart
│     ├─ profile_edit_view.dart
│     ├─ profile_view.dart
│     ├─ register_view.dart
│     ├─ reset_password_view.dart
│     ├─ test_step_count.dart
│     ├─ verify_view.dart
│     ├─ view_test.dart
│     └─ welcome_view.dart
├─ logo.png
├─ pubspec.lock
├─ pubspec.yaml
├─ splashscreen.yaml
├─ test
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json
```

©generated by [Project Tree Generator](https://woochanleee.github.io/project-tree-generator)
