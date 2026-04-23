# LifeFlow APK 构建指南

## 环境要求

1. **Flutter SDK** (>= 3.0.0)
   - 下载地址: https://docs.flutter.dev/get-started/install
   - 配置环境变量后执行: `flutter doctor`

2. **Android Studio** 或 **Android SDK**
   - Android SDK 版本: 34
   - 最低 SDK 版本: 21

3. **JDK** (>= 17)
   - 推荐使用 OpenJDK 17

## 快速构建

### Linux/Mac
```bash
cd /home/chen/ComateProjects/personal_manager/lifeflow_app
./build_apk.sh
```

### Windows
```cmd
cd lifeflow_app
build_apk.bat
```

## 手动构建步骤

1. **获取依赖**
   ```bash
   flutter pub get
   ```

2. **分析代码**
   ```bash
   flutter analyze
   ```

3. **构建 Release APK**
   ```bash
   flutter build apk --release
   ```

4. **构建 App Bundle (AAB)**
   ```bash
   flutter build appbundle --release
   ```

## 输出文件

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

## 签名信息

- **密钥库**: `android/app/lifeflow.keystore`
- **别名**: `lifeflow`
- **密码**: `lifeflow123`

## 安装到设备

```bash
flutter install
```

或手动安装:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 常见问题

1. **Flutter 命令未找到**
   - 确保 Flutter SDK 已添加到 PATH

2. **Android SDK 未找到**
   - 设置 ANDROID_HOME 环境变量

3. **构建失败**
   - 运行 `flutter clean` 后重试
   - 确保所有依赖都已下载: `flutter pub get`

## 项目结构

```
lifeflow_app/
├── android/           # Android 原生配置
├── lib/              # Flutter 源代码
│   ├── core/         # 主题和配置
│   ├── models/       # 数据模型
│   ├── providers/    # 状态管理
│   ├── screens/      # 页面
│   ├── services/     # 服务
│   └── widgets/      # 组件
├── pubspec.yaml      # 依赖配置
└── build_apk.sh      # 构建脚本
```
