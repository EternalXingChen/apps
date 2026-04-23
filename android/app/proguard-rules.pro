# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn io.flutter.embedding.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep SQLCipher
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.* { *; }

# Keep encryption
-keep class com.example.lifeflow.utils.** { *; }
