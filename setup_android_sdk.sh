#!/bin/bash

# Android SDK 安装脚本

set -e

echo "========================================="
echo "Android SDK 安装脚本"
echo "========================================="

# 创建目录
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools

# 下载命令行工具
echo "📥 下载 Android SDK 命令行工具..."
if [ ! -f "commandlinetools-linux-11076708_latest.zip" ]; then
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
fi

# 解压
echo "📦 解压..."
unzip -q commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest

# 设置环境变量
echo ""
echo "⚙️  配置环境变量..."
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc

# 立即生效
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 安装必要组件
echo ""
echo "📲 安装 SDK 组件..."
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo ""
echo "========================================="
echo "✅ Android SDK 安装完成！"
echo "========================================="
echo ""
echo "请运行以下命令使环境变量生效:"
echo "  source ~/.bashrc"
echo ""
echo "然后可以构建 APK:"
echo "  cd /home/chen/ComateProjects/personal_manager/lifeflow_app"
echo "  flutter build apk --release"
