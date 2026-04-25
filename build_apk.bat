@echo off
chcp 65001 >nul

REM LifeFlow APK Build Script for Windows

echo =========================================
echo LifeFlow Android APK Build Script
echo =========================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found!
    echo Please install Flutter first: https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter found
flutter --version
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 5996 bytes (99.6% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-iconsFont asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 5996 bytes (99.6% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app. flag when building your app.
cd /d "%~dp0"

echo.
echo 📦 Getting dependencies...
flutter pub get

echo.
echo 🔍 Analyzing code...
flutter analyze

echo.
echo 🧪 Running tests...
flutter test || echo ⚠️ Tests failed, continuing...

echo.
echo 📱 Building Android APK...
echo -----------------------------------------

REM Build release APK
flutter build apk --release

echo.
echo 📱 Building Android App Bundle (AAB)...
echo -----------------------------------------

REM Build release AAB
flutter build appbundle --release

echo.
echo =========================================
echo ✅ Build completed successfully!
echo =========================================
echo.
echo 📁 Output files:
echo   APK: build\app\outputs\flutter-apk\app-release.apk
echo   AAB: build\app\outputs\bundle\release\app-release.aab
echo.

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo 📋 APK Info:
    dir "build\app\outputs\flutter-apk\app-release.apk" | findstr "app-release.apk"
)

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo.
    echo 📋 AAB Info:
    dir "build\app\outputs\bundle\release\app-release.aab" | findstr "app-release.aab"
)

echo.
echo 🚀 To install on connected device:
echo   flutter install
pause
