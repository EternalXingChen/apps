import 'package:flutter/material.dart';

/// 应用程序常量
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = 'LifeFlow';
  static const String appVersion = '1.0.0';
  static const String appTagline = '记录生活，管理时间，掌控财务';

  // 主题颜色
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00BFA6);
  static const Color accentColor = Color(0xFFFF6584);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);

  // 财务颜色
  static const Color incomeColor = Color(0xFF00BFA6);
  static const Color expenseColor = Color(0xFFFF6584);

  // 情绪颜色
  static const Map<String, Color> moodColors = {
    'happy': Color(0xFFFFD93D),
    'calm': Color(0xFF6BCB77),
    'sad': Color(0xFF4D96FF),
    'anxious': Color(0xFFFF6B6B),
    'angry': Color(0xFFFF4757),
    'tired': Color(0xFF95A5A6),
    'excited': Color(0xFFFF9F43),
    'grateful': Color(0xFF26DE81),
  };

  // 分类图标
  static const Map<String, IconData> categoryIcons = {
    // 支出
    'food': Icons.restaurant,
    'transport': Icons.directions_car,
    'shopping': Icons.shopping_bag,
    'entertainment': Icons.movie,
    'housing': Icons.home,
    'medical': Icons.local_hospital,
    'education': Icons.school,
    'other_expense': Icons.more_horiz,
    // 收入
    'salary': Icons.work,
    'bonus': Icons.card_giftcard,
    'investment': Icons.trending_up,
    'other_income': Icons.more_horiz,
  };

  // 默认分类
  static const List<String> expenseCategories = [
    '餐饮',
    '交通',
    '购物',
    '娱乐',
    '居住',
    '医疗',
    '教育',
    '其他支出',
  ];

  static const List<String> incomeCategories = [
    '工资',
    '奖金',
    '投资',
    '其他收入',
  ];

  // 任务优先级
  static const Map<int, String> priorityLabels = {
    1: '低',
    2: '中',
    3: '高',
  };

  static const Map<int, Color> priorityColors = {
    1: Colors.green,
    2: Colors.orange,
    3: Colors.red,
  };

  // 重复规则
  static const Map<String, String> repeatRules = {
    'none': '不重复',
    'daily': '每天',
    'weekly': '每周',
    'monthly': '每月',
    'yearly': '每年',
  };

  // 数据库
  static const String databaseName = 'lifeflow.db';
  static const int databaseVersion = 1;

  // 存储键
  static const String keyUserSettings = 'user_settings';
  static const String keyLastSync = 'last_sync';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyBudgetAlert = 'budget_alert';
  static const String keyTaskReminder = 'task_reminder';

  // 动画时长
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 200);

  // 分页
  static const int pageSize = 20;

  // 图表
  static const int maxChartEntries = 7;
  static const int maxPieChartEntries = 5;
}
