# LifeFlow APK 构建说明

## 当前环境状态

当前系统已安装:
- ✅ Flutter SDK (位于 /home/chen/flutter)
- ✅ Java JDK
- ❌ Android SDK (未安装，无法构建 APK)

## 解决方案

### 方案 1: 安装 Android SDK (推荐)

```bash
# 1. 下载 Android Command Line Tools
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest

# 2. 设置环境变量
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 3. 安装必要的 SDK 组件
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 4. 构建 APK
cd /home/chen/ComateProjects/personal_manager/lifeflow_app
flutter build apk --release
```

### 方案 2: 使用 Android Studio

1. 下载并安装 Android Studio
2. 打开 Android Studio，安装 Android SDK
3. 配置 Flutter 使用 Android Studio 的 SDK:
   ```bash
   flutter config --android-sdk=/path/to/android/sdk
   ```

### 方案 3: 使用 Docker

```bash
# 使用预配置的 Flutter Docker 镜像
docker run --rm -v $(pwd):/app -w /app \
  cirrusci/flutter:stable \
  flutter build apk --release
```

### 方案 4: 使用 GitHub Actions (CI/CD)

已创建 `.github/workflows/build.yml` 文件，可以推送到 GitHub 自动构建。

## 项目已准备就绪

项目配置已完成:
- ✅ Android 项目结构
- ✅ 签名证书 (lifeflow.keystore)
- ✅ 构建配置 (build.gradle)
- ✅ 依赖配置 (pubspec.yaml)
- ✅ 代码错误修复

## 构建输出

构建成功后，APK 文件将位于:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 应用信息

- **应用名称**: LifeFlow
- **包名**: com.example.lifeflow
- **版本**: 1.0.0+1
- **最低 SDK**: 21 (Android 5.0)
- **目标 SDK**: 34 (Android 14)

## 签名信息

- **密钥库**: android/app/lifeflow.keystore
- **别名**: lifeflow
- **密码**: lifeflow123
- **有效期**: 10,000 天

## 功能特性

- 📊 财务管理 - 收支记录、分类统计
- 📝 日记记录 - 心情标记、多媒体支持
- ✅ 任务管理 - 优先级、提醒、重复
- 📅 日历集成 - 统一视图
- 🔒 数据加密 - AES-256 加密
- 🌐 多语言支持 - 中文/英文
- 🎨 Material Design 3
