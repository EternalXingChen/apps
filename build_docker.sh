#!/bin/bash

# Docker 构建脚本 - 用于在没有 Android SDK 的环境中构建 APK

set -e

echo "========================================="
echo "LifeFlow Docker Build Script"
echo "========================================="

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found!"
    echo "Please install Docker first"
    exit 1
fi

echo "✅ Docker found"

# 创建 Dockerfile
cat > Dockerfile << 'EOF'
FROM cirrusci/flutter:stable

WORKDIR /app

# 复制项目文件
COPY . .

# 获取依赖
RUN flutter pub get

# 构建 APK
RUN flutter build apk --release

# 输出目录
VOLUME ["/app/build"]
EOF

echo "📦 Building Docker image..."
docker build -t lifeflow-builder .

echo ""
echo "✅ Build completed!"
echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
