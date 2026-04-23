#!/bin/bash

# LifeFlow APK Build Script

set -e

echo "========================================="
echo "LifeFlow Android APK Build Script"
echo "========================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found!"
    echo "Please install Flutter first: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found"
flutter --version

cd "$(dirname "$0")"

echo ""
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔍 Analyzing code..."
flutter analyze

echo ""
echo "🧪 Running tests..."
flutter test || echo "⚠️ Tests failed, continuing..."

echo ""
echo "📱 Building Android APK..."
echo "-----------------------------------------"

# Build release APK
flutter build apk --release

echo ""
echo "📱 Building Android App Bundle (AAB)..."
echo "-----------------------------------------"

# Build release AAB
flutter build appbundle --release

echo ""
echo "========================================="
echo "✅ Build completed successfully!"
echo "========================================="
echo ""
echo "📁 Output files:"
echo "  APK: build/app/outputs/flutter-apk/app-release.apk"
echo "  AAB: build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "📋 APK Info:"
ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || echo "  APK not found"
echo ""
echo "📋 AAB Info:"
ls -lh build/app/outputs/bundle/release/app-release.aab 2>/dev/null || echo "  AAB not found"
echo ""
echo "🚀 To install on connected device:"
echo "  flutter install"
echo ""
