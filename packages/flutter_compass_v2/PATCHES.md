# Local patches to flutter_compass_v2 1.0.3

Vendored copy of [`flutter_compass_v2` 1.0.3](https://pub.dev/packages/flutter_compass_v2)
(see `LICENSE`). It is a dependency of `flutter_qiblah`. The Dart API is untouched.

## Why

The published `android/build.gradle` compiles against Android SDK 33 and ships
an AGP 7.4 / Kotlin 1.9 `buildscript`. With current AndroidX (pulled in by the
Flutter embedding) the build fails at `checkDebugAarMetadata` because
`androidx.fragment` and `androidx.window` need compileSdk 34 or later.

## What changed

Only `android/build.gradle`: removed the `buildscript` block, applied just
`com.android.library`, raised `compileSdk` to 36 and `minSdk` to 21.

## Removing this

Delete this directory and its `dependency_overrides` entry in the app's
`pubspec.yaml` once upstream publishes a fixed release.
