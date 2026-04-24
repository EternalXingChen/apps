# 推送到 GitHub 并触发 Actions 构建

## 当前状态
- ✅ 项目已初始化 Git
- ✅ 远程仓库已配置: `https://github.com/EternalXingChen/apps.git`
- ✅ GitHub Actions 配置已完成 (`.github/workflows/build.yml`)
- ❌ 需要身份验证才能推送

## 推送步骤

### 方法 1: 使用 GitHub Token (推荐)

1. **创建 Personal Access Token**
   - 访问: https://github.com/settings/tokens
   - 点击 "Generate new token (classic)"
   - 选择权限: `repo` (完整仓库访问)
   - 生成并复制 Token

2. **配置 Git 使用 Token**
   ```bash
   cd /home/chen/ComateProjects/personal_manager/lifeflow_app
   
   # 方法 A: 直接修改远程 URL
   git remote set-url origin https://YOUR_TOKEN@github.com/EternalXingChen/apps.git
   
   # 方法 B: 使用 credential helper
   git config credential.helper store
   # 然后推送时会提示输入用户名和密码，密码处输入 Token
   ```

3. **推送代码**
   ```bash
   git add .
   git commit -m "Add LifeFlow app with GitHub Actions"
   git push origin main
   ```

### 方法 2: 使用 SSH 密钥

1. **生成 SSH 密钥** (如果没有)
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   cat ~/.ssh/id_ed25519.pub
   ```

2. **添加公钥到 GitHub**
   - 访问: https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥内容

3. **修改远程 URL 为 SSH**
   ```bash
   git remote set-url origin git@github.com:EternalXingChen/apps.git
   ```

4. **推送**
   ```bash
   git push origin main
   ```

## 触发 GitHub Actions 构建

推送代码后，GitHub Actions 会自动触发构建。你可以在以下地址查看构建状态：

```
https://github.com/EternalXingChen/apps/actions
```

### 手动触发构建

1. 访问 Actions 页面
2. 点击左侧的 "Build Android APK"
3. 点击右上角的 "Run workflow" 按钮
4. 选择分支 (main)
5. 点击 "Run workflow"

## 下载构建产物

构建完成后 (约 5-10 分钟)：

1. 进入 Actions 页面查看运行记录
2. 点击最新的工作流运行
3. 滚动到页面底部的 "Artifacts" 部分
4. 下载:
   - `release-apk` - Android APK 文件
   - `release-aab` - Android App Bundle 文件

## 快速命令汇总

```bash
cd /home/chen/ComateProjects/personal_manager/lifeflow_app

# 配置 Token (替换 YOUR_TOKEN)
git remote set-url origin https://YOUR_TOKEN@github.com/EternalXingChen/apps.git

# 提交并推送
git add .
git commit -m "Add LifeFlow app"
git push origin main

# 查看状态
git status
```

## 故障排除

### 推送被拒绝
```bash
# 先拉取最新代码
git pull origin main --rebase

# 然后再推送
git push origin main
```

### Actions 未触发
- 检查 `.github/workflows/build.yml` 是否存在
- 确认文件已提交到仓库
- 检查 GitHub 仓库的 Actions 是否已启用

### 构建失败
- 查看 Actions 日志获取详细错误信息
- 确保 `pubspec.yaml` 配置正确
- 检查 Android 项目配置
