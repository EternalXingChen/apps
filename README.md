# LifeFlow - 个人生活管理应用

一款集财务记账、心情日记、任务提醒于一体的个人生活管理 Flutter 应用。

## 功能特性

### 1. 财务记账
- 快速记账（支持语音输入）
- 收支分类管理
- 多账户支持（现金、银行卡、电子钱包）
- 月度/年度财务报表
- 预算设置与提醒
- 数据导出（CSV/Excel）

### 2. 心情日记
- 富文本日记编辑
- Emoji 心情标签
- 图片/视频附件
- 地理位置记录
- 日记时间轴
- 心情统计图表

### 3. 任务提醒
- 任务创建与管理
- 优先级设置
- 重复提醒（日/周/月/年）
- 本地推送通知
- 任务完成统计

### 4. 日历集成
- 月视图/周视图/日视图
- 事件与任务显示
- 快速添加事件
- 农历显示
- 节假日标注

## 技术栈

- **框架**: Flutter 3.16+
- **状态管理**: Riverpod
- **本地数据库**: Drift (SQLite)
- **图表**: fl_chart
- **日历**: table_calendar
- **通知**: flutter_local_notifications
- **存储**: shared_preferences, path_provider

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── app.dart                  # 应用配置
├── core/                     # 核心模块
│   ├── constants/            # 常量定义
│   ├── theme/                # 主题配置
│   ├── utils/                # 工具类
│   └── extensions/           # 扩展方法
├── data/                     # 数据层
│   ├── database/             # 数据库
│   ├── models/               # 数据模型
│   └── repositories/         # 数据仓库
├── domain/                   # 领域层
│   ├── entities/             # 实体类
│   └── services/             # 服务类
├── presentation/             # 表现层
│   ├── providers/            # 状态管理
│   ├── screens/              # 页面
│   ├── widgets/              # 组件
│   └── viewmodels/           # 视图模型
└── services/                 # 服务层
    ├── notification_service.dart
    └── sync_service.dart
```

## 运行项目

```bash
# 安装依赖
flutter pub get

# 生成代码（数据库模型等）
flutter pub run build_runner build

# 运行应用
flutter run
```

## 开发计划

### Phase 1 - 基础架构
- [x] 项目初始化
- [x] 数据库设计
- [x] 主题配置
- [ ] 基础组件库

### Phase 2 - 财务模块
- [ ] 记账功能
- [ ] 分类管理
- [ ] 报表统计
- [ ] 预算功能

### Phase 3 - 日记模块
- [ ] 日记编辑
- [ ] 心情标签
- [ ] 媒体附件
- [ ] 时间轴

### Phase 4 - 任务模块
- [ ] 任务管理
- [ ] 提醒功能
- [ ] 重复规则
- [ ] 日历集成

### Phase 5 - 高级功能
- [ ] 数据同步
- [ ] 数据备份
- [ ] 生物识别
- [ ] 小组件

## 设计规范

### 颜色系统
- 主色: #4A90E2 (蓝色)
- 收入: #4CAF50 (绿色)
- 支出: #F44336 (红色)
- 背景: #F5F5F5 (浅灰)
- 文字: #212121 (深灰)

### 字体规范
- 标题: 20-24px, SemiBold
- 正文: 14-16px, Regular
- 辅助: 12px, Regular

## 许可证

MIT License

## 作者

LifeFlow Team
