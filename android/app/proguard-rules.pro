# ML Kit image labeling — keep classes that R8 would otherwise strip/rename.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
