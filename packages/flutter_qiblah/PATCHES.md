# Local patches to flutter_qiblah 3.2.0

This is a vendored copy of [`flutter_qiblah` 3.2.0](https://pub.dev/packages/flutter_qiblah)
(MIT, © 2020 medyas, see `LICENSE`). The Dart API is untouched.

## Why

The published Android build file does not build with current Gradle:

- it declares `jcenter()`, which Gradle 9 removed
  (`Could not find method jcenter()`),
- it pins an AGP 7.3 classpath and Kotlin 1.7.10 inside the library itself.

## What changed

Only `android/build.gradle`: removed the `buildscript` block and `jcenter()`,
applied `com.android.library` and `kotlin-android` (versions come from the host app), and raised `compileSdk` to 36 (its dependency flutter_compass_v2 needs it).
The Kotlin plugin class is compiled by the host app's AGP.

## Removing this

Delete this directory and the `dependency_overrides` entry in the app's
`pubspec.yaml` once upstream publishes a Gradle-9-compatible release.
