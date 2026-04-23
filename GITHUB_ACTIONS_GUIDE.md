# GitHub Actions 打包指南

## 快速开始

### 1. 创建 GitHub 仓库

```bash
# 在 lifeflow_app 目录下初始化 git
cd /home/chen/ComateProjects/personal_manager/lifeflow_app
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: LifeFlow app"

# 创建 GitHub 仓库（在 GitHub 网站上创建，或使用 gh CLI）
# 然后推送
git remote add origin https://github.com/yourusername/lifeflow.git
git push -u origin main
```

### 2. 配置文件说明

`.github/workflows/build.yml` 已创建，包含以下功能：

- **触发条件**:
  - 推送到 main/master 分支
  - 发起 Pull Request
  - 手动触发 (workflow_dispatch)

- **构建步骤**:
  1. 检出代码
  2. 设置 JDK 17
  3. 设置 Flutter 3.16.0
  4. 获取依赖
  5. 代码分析
  6. 运行测试
  7. 构建 APK
  8. 构建 AAB
  9. 上传构建产物

### 3. 触发构建

#### 方式 1: 推送代码
```bash
git add .
git commit -m "Update app"
git push origin main
```

#### 方式 2: 手动触发
1. 打开 GitHub 仓库页面
2. 点击 "Actions" 标签
3. 选择 "Build Android APK" 工作流
4. 点击 "Run workflow" 按钮

### 4. 下载构建产物

构建完成后：
1. 进入 GitHub 仓库的 Actions 页面
2. 点击最新的工作流运行记录
3. 在 Artifacts 部分下载:
   - `release-apk` - APK 文件
   - `release-aab` - AAB 文件

## 高级配置

### 添加版本标签自动构建

编辑 `.github/workflows/build.yml`，添加标签触发：

```yaml
on:
  push:
    branches: [ main, master ]
    tags:
      - 'v*'  # 推送 v1.0.0 等标签时触发
```

### 发布到 GitHub Releases

添加发布步骤：

```yaml
    - name: Create Release
      uses: softprops/action-gh-release@v1
      if: startsWith(github.ref, 'refs/tags/')
      with:
        files: |
          build/app/outputs/flutter-apk/app-release.apk
          build/app/outputs/bundle/release/app-release.aab
```

### 使用缓存加速构建

添加依赖缓存：

```yaml
    - name: Cache Flutter dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.pub-cache
          build/
        key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
```

## 完整优化版 workflow

```yaml
name: Build and Release Android APK

on:
  push:
    branches: [ main, master ]
    tags:
      - 'v*'
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
        cache: true
    
    - name: Cache dependencies
      uses: actions/cache@v3
      with:
        path: |
          ~/.pub-cache
          build/
        key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Run tests
      run: flutter test
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Build App Bundle
      run: flutter build appbundle --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: lifeflow-apk-${{ github.run_number }}
        path: build/app/outputs/flutter-apk/app-release.apk
    
    - name: Upload AAB
      uses: actions/upload-artifact@v4
      with:
        name: lifeflow-aab-${{ github.run_number }}
        path: build/app/outputs/bundle/release/app-release.aab
    
    - name: Create Release
      uses: softprops/action-gh-release@v1
      if: startsWith(github.ref, 'refs/tags/')
      with:
        files: |
          build/app/outputs/flutter-apk/app-release.apk
          build/app/outputs/bundle/release/app-release.aab
        generate_release_notes: true
```

## 发布新版本流程

```bash
# 1. 更新版本号（在 pubspec.yaml 中）
# version: 1.0.0+1

# 2. 提交更改
git add pubspec.yaml
git commit -m "Bump version to 1.0.0"

# 3. 创建标签
git tag -a v1.0.0 -m "Release version 1.0.0"

# 4. 推送标签
git push origin main --tags
```

推送标签后，GitHub Actions 会自动构建并创建 Release。

## 故障排除

### 构建失败
1. 检查代码是否有错误: `flutter analyze`
2. 检查测试是否通过: `flutter test`
3. 查看 GitHub Actions 日志获取详细信息

### 签名问题
确保 `android/app/lifeflow.keystore` 已提交到仓库（已配置好）。

### 依赖问题
如果依赖下载失败，尝试：
```yaml
    - name: Clean and get dependencies
      run: |
        flutter clean
        flutter pub get
```
