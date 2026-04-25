# LifeFlow - 个人生活管理应用

## 项目概述

LifeFlow 是一款集成记账、日记、任务提醒的移动端个人生活管理应用。

## 核心功能

### 1. 财务管理 (Finance Management)
- 快速记账（金额、分类、时间戳、账户类型）
- 收支统计与图表分析
- 预算设置与提醒
- 多账户管理

### 2. 日记记录 (Journaling)
- 富文本日记编辑
- 心情标记（Emoji）
- 多媒体附件（图片、音频）
- 位置记录

### 3. 任务与提醒 (Tasks & Reminders)
- 任务创建（标题、截止时间、优先级）
- 重复规则设置
- 推送通知提醒
- 任务分类管理

### 4. 集成日历 (Integrated Calendar)
- 月视图/周视图/日视图
- 事件与任务同步显示
- 快速添加日程

## 技术栈

- **前端框架**: React Native / Flutter
- **数据库**: SQLite (Realm)
- **云同步**: iCloud / WebDAV
- **加密**: AES-256
- **平台**: iOS, Android

## 项目结构

```
personal_manager/
├── src/
│   ├── components/       # 可复用组件
│   ├── screens/          # 页面组件
│   ├── navigation/       # 导航配置
│   ├── services/         # 业务逻辑服务
│   ├── database/         # 数据库模型与操作
│   ├── utils/            # 工具函数
│   ├── constants/        # 常量定义
│   └── assets/           # 图片、字体等资源
├── android/              # Android 原生代码
├── ios/                  # iOS 原生代码
├── tests/                # 测试文件
└── docs/                 # 项目文档
```

## 开发环境

- Node.js >= 18
- React Native CLI
- Android Studio / Xcode

## 安装与运行

```bash
# 安装依赖
npm install

# 启动开发服务器
npm start

# 运行 Android
npm run android

# 运行 iOS
npm run ios
```

## 版本信息

- **版本**: v1.0.0
- **作者**: LifeFlow Project
- **许可证**: © 2026 LifeFlow Project


依然不能保存数据，保存数据成功后却不能看到保存的数据信息

要解决这个问题，首先需要确保你的应用正确地实现了数据的保存和读取功能。以下是一些步骤和建议来帮助你调试并解决问题：
1. 首页概览日记跳转过去后，页面空白，日记内容不显示
2. 支出页面新增一笔支出后，财务概览页无显示，返回首页概览，今日支出显示为0
3. 任务管理页面新增任务后，任务点击保存无响应

lifeflow_app 打包apk 

保存数据功能依然存在问题，请分析代码，找出问题所在

清空之前的打包数据，重新打包