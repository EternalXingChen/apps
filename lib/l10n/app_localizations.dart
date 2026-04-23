import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegateDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      'appName': 'LifeFlow',
      'home': '首页',
      'tasks': '任务',
      'finance': '财务',
      'journal': '日记',
      'calendar': '日历',
      'settings': '设置',
      'add': '添加',
      'edit': '编辑',
      'delete': '删除',
      'save': '保存',
      'cancel': '取消',
      'confirm': '确认',
      'search': '搜索',
      'filter': '筛选',
      'sort': '排序',
      'noData': '暂无数据',
      'loading': '加载中...',
      'error': '出错了',
      'retry': '重试',
      'success': '成功',
      'failed': '失败',
      'income': '收入',
      'expense': '支出',
      'balance': '结余',
      'totalIncome': '总收入',
      'totalExpense': '总支出',
      'today': '今天',
      'yesterday': '昨天',
      'tomorrow': '明天',
      'thisWeek': '本周',
      'thisMonth': '本月',
      'thisYear': '本年',
      'custom': '自定义',
      'all': '全部',
      'pending': '待办',
      'completed': '已完成',
      'overdue': '已逾期',
      'highPriority': '高优先级',
      'mediumPriority': '中优先级',
      'lowPriority': '低优先级',
      'noPriority': '无优先级',
      'daily': '每天',
      'weekly': '每周',
      'monthly': '每月',
      'yearly': '每年',
      'none': '无',
      'cash': '现金',
      'creditCard': '信用卡',
      'debitCard': '借记卡',
      'alipay': '支付宝',
      'wechatPay': '微信支付',
      'other': '其他',
      'food': '餐饮',
      'transport': '交通',
      'shopping': '购物',
      'entertainment': '娱乐',
      'housing': '居住',
      'medical': '医疗',
      'education': '教育',
      'salary': '工资',
      'bonus': '奖金',
      'investment': '投资',
      'writeJournal': '写日记',
      'journalTitle': '日记标题',
      'journalContent': '日记内容',
      'mood': '心情',
      'location': '位置',
      'weather': '天气',
      'addImage': '添加图片',
      'encrypt': '加密',
      'taskTitle': '任务标题',
      'taskDescription': '任务描述',
      'dueDate': '截止日期',
      'dueTime': '截止时间',
      'reminder': '提醒',
      'repeat': '重复',
      'category': '分类',
      'amount': '金额',
      'note': '备注',
      'date': '日期',
      'time': '时间',
      'statistics': '统计',
      'trend': '趋势',
      'categoryBreakdown': '分类统计',
      'recentTransactions': '最近交易',
      'viewAll': '查看全部',
      'backup': '备份',
      'restore': '恢复',
      'sync': '同步',
      'theme': '主题',
      'language': '语言',
      'notification': '通知',
      'security': '安全',
      'about': '关于',
      'version': '版本',
      'logout': '退出登录',
      'deleteAccount': '删除账户',
      'welcome': '欢迎使用 LifeFlow',
      'welcomeSubtitle': '管理你的生活，记录每一刻',
      'getStarted': '开始使用',
      'skip': '跳过',
      'next': '下一步',
      'finish': '完成',
      'onboarding1Title': '财务管理',
      'onboarding1Desc': '记录每一笔收支，掌握财务状况',
      'onboarding2Title': '日记记录',
      'onboarding2Desc': '记录生活点滴，留下美好回忆',
      'onboarding3Title': '任务管理',
      'onboarding3Desc': '规划每日任务，提高工作效率',
      'onboarding4Title': '日历集成',
      'onboarding4Desc': '统一管理日程，不再错过重要事项',
    },
    'en': {
      'appName': 'LifeFlow',
      'home': 'Home',
      'tasks': 'Tasks',
      'finance': 'Finance',
      'journal': 'Journal',
      'calendar': 'Calendar',
      'settings': 'Settings',
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'noData': 'No Data',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'success': 'Success',
      'failed': 'Failed',
      'income': 'Income',
      'expense': 'Expense',
      'balance': 'Balance',
      'totalIncome': 'Total Income',
      'totalExpense': 'Total Expense',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'tomorrow': 'Tomorrow',
      'thisWeek': 'This Week',
      'thisMonth': 'This Month',
      'thisYear': 'This Year',
      'custom': 'Custom',
      'all': 'All',
      'pending': 'Pending',
      'completed': 'Completed',
      'overdue': 'Overdue',
      'highPriority': 'High Priority',
      'mediumPriority': 'Medium Priority',
      'lowPriority': 'Low Priority',
      'noPriority': 'No Priority',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'none': 'None',
      'cash': 'Cash',
      'creditCard': 'Credit Card',
      'debitCard': 'Debit Card',
      'alipay': 'Alipay',
      'wechatPay': 'WeChat Pay',
      'other': 'Other',
      'food': 'Food',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'housing': 'Housing',
      'medical': 'Medical',
      'education': 'Education',
      'salary': 'Salary',
      'bonus': 'Bonus',
      'investment': 'Investment',
      'writeJournal': 'Write Journal',
      'journalTitle': 'Journal Title',
      'journalContent': 'Journal Content',
      'mood': 'Mood',
      'location': 'Location',
      'weather': 'Weather',
      'addImage': 'Add Image',
      'encrypt': 'Encrypt',
      'taskTitle': 'Task Title',
      'taskDescription': 'Task Description',
      'dueDate': 'Due Date',
      'dueTime': 'Due Time',
      'reminder': 'Reminder',
      'repeat': 'Repeat',
      'category': 'Category',
      'amount': 'Amount',
      'note': 'Note',
      'date': 'Date',
      'time': 'Time',
      'statistics': 'Statistics',
      'trend': 'Trend',
      'categoryBreakdown': 'Category Breakdown',
      'recentTransactions': 'Recent Transactions',
      'viewAll': 'View All',
      'backup': 'Backup',
      'restore': 'Restore',
      'sync': 'Sync',
      'theme': 'Theme',
      'language': 'Language',
      'notification': 'Notification',
      'security': 'Security',
      'about': 'About',
      'version': 'Version',
      'logout': 'Logout',
      'deleteAccount': 'Delete Account',
      'welcome': 'Welcome to LifeFlow',
      'welcomeSubtitle': 'Manage your life, record every moment',
      'getStarted': 'Get Started',
      'skip': 'Skip',
      'next': 'Next',
      'finish': 'Finish',
      'onboarding1Title': 'Finance Management',
      'onboarding1Desc': 'Track every income and expense, master your finances',
      'onboarding2Title': 'Journal Recording',
      'onboarding2Desc': 'Record life moments, preserve beautiful memories',
      'onboarding3Title': 'Task Management',
      'onboarding3Desc': 'Plan daily tasks, improve work efficiency',
      'onboarding4Title': 'Calendar Integration',
      'onboarding4Desc': 'Unified schedule management, never miss important events',
    },
  };

  String get appName => _localizedValues[locale.languageCode]?['appName'] ?? 'LifeFlow';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get tasks => _localizedValues[locale.languageCode]?['tasks'] ?? 'Tasks';
  String get finance => _localizedValues[locale.languageCode]?['finance'] ?? 'Finance';
  String get journal => _localizedValues[locale.languageCode]?['journal'] ?? 'Journal';
  String get calendar => _localizedValues[locale.languageCode]?['calendar'] ?? 'Calendar';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get add => _localizedValues[locale.languageCode]?['add'] ?? 'Add';
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? 'Edit';
  String get delete => _localizedValues[locale.languageCode]?['delete'] ?? 'Delete';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get confirm => _localizedValues[locale.languageCode]?['confirm'] ?? 'Confirm';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? 'Search';
  String get filter => _localizedValues[locale.languageCode]?['filter'] ?? 'Filter';
  String get sort => _localizedValues[locale.languageCode]?['sort'] ?? 'Sort';
  String get noData => _localizedValues[locale.languageCode]?['noData'] ?? 'No Data';
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? 'Loading...';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? 'Retry';
  String get success => _localizedValues[locale.languageCode]?['success'] ?? 'Success';
  String get failed => _localizedValues[locale.languageCode]?['failed'] ?? 'Failed';
  String get income => _localizedValues[locale.languageCode]?['income'] ?? 'Income';
  String get expense => _localizedValues[locale.languageCode]?['expense'] ?? 'Expense';
  String get balance => _localizedValues[locale.languageCode]?['balance'] ?? 'Balance';
  String get totalIncome => _localizedValues[locale.languageCode]?['totalIncome'] ?? 'Total Income';
  String get totalExpense => _localizedValues[locale.languageCode]?['totalExpense'] ?? 'Total Expense';
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get yesterday => _localizedValues[locale.languageCode]?['yesterday'] ?? 'Yesterday';
  String get tomorrow => _localizedValues[locale.languageCode]?['tomorrow'] ?? 'Tomorrow';
  String get thisWeek => _localizedValues[locale.languageCode]?['thisWeek'] ?? 'This Week';
  String get thisMonth => _localizedValues[locale.languageCode]?['thisMonth'] ?? 'This Month';
  String get thisYear => _localizedValues[locale.languageCode]?['thisYear'] ?? 'This Year';
  String get custom => _localizedValues[locale.languageCode]?['custom'] ?? 'Custom';
  String get all => _localizedValues[locale.languageCode]?['all'] ?? 'All';
  String get pending => _localizedValues[locale.languageCode]?['pending'] ?? 'Pending';
  String get completed => _localizedValues[locale.languageCode]?['completed'] ?? 'Completed';
  String get overdue => _localizedValues[locale.languageCode]?['overdue'] ?? 'Overdue';
  String get highPriority => _localizedValues[locale.languageCode]?['highPriority'] ?? 'High Priority';
  String get mediumPriority => _localizedValues[locale.languageCode]?['mediumPriority'] ?? 'Medium Priority';
  String get lowPriority => _localizedValues[locale.languageCode]?['lowPriority'] ?? 'Low Priority';
  String get noPriority => _localizedValues[locale.languageCode]?['noPriority'] ?? 'No Priority';
  String get daily => _localizedValues[locale.languageCode]?['daily'] ?? 'Daily';
  String get weekly => _localizedValues[locale.languageCode]?['weekly'] ?? 'Weekly';
  String get monthly => _localizedValues[locale.languageCode]?['monthly'] ?? 'Monthly';
  String get yearly => _localizedValues[locale.languageCode]?['yearly'] ?? 'Yearly';
  String get none => _localizedValues[locale.languageCode]?['none'] ?? 'None';
  String get cash => _localizedValues[locale.languageCode]?['cash'] ?? 'Cash';
  String get creditCard => _localizedValues[locale.languageCode]?['creditCard'] ?? 'Credit Card';
  String get debitCard => _localizedValues[locale.languageCode]?['debitCard'] ?? 'Debit Card';
  String get alipay => _localizedValues[locale.languageCode]?['alipay'] ?? 'Alipay';
  String get wechatPay => _localizedValues[locale.languageCode]?['wechatPay'] ?? 'WeChat Pay';
  String get other => _localizedValues[locale.languageCode]?['other'] ?? 'Other';
  String get food => _localizedValues[locale.languageCode]?['food'] ?? 'Food';
  String get transport => _localizedValues[locale.languageCode]?['transport'] ?? 'Transport';
  String get shopping => _localizedValues[locale.languageCode]?['shopping'] ?? 'Shopping';
  String get entertainment => _localizedValues[locale.languageCode]?['entertainment'] ?? 'Entertainment';
  String get housing => _localizedValues[locale.languageCode]?['housing'] ?? 'Housing';
  String get medical => _localizedValues[locale.languageCode]?['medical'] ?? 'Medical';
  String get education => _localizedValues[locale.languageCode]?['education'] ?? 'Education';
  String get salary => _localizedValues[locale.languageCode]?['salary'] ?? 'Salary';
  String get bonus => _localizedValues[locale.languageCode]?['bonus'] ?? 'Bonus';
  String get investment => _localizedValues[locale.languageCode]?['investment'] ?? 'Investment';
  String get writeJournal => _localizedValues[locale.languageCode]?['writeJournal'] ?? 'Write Journal';
  String get journalTitle => _localizedValues[locale.languageCode]?['journalTitle'] ?? 'Journal Title';
  String get journalContent => _localizedValues[locale.languageCode]?['journalContent'] ?? 'Journal Content';
  String get mood => _localizedValues[locale.languageCode]?['mood'] ?? 'Mood';
  String get location => _localizedValues[locale.languageCode]?['location'] ?? 'Location';
  String get weather => _localizedValues[locale.languageCode]?['weather'] ?? 'Weather';
  String get addImage => _localizedValues[locale.languageCode]?['addImage'] ?? 'Add Image';
  String get encrypt => _localizedValues[locale.languageCode]?['encrypt'] ?? 'Encrypt';
  String get taskTitle => _localizedValues[locale.languageCode]?['taskTitle'] ?? 'Task Title';
  String get taskDescription => _localizedValues[locale.languageCode]?['taskDescription'] ?? 'Task Description';
  String get dueDate => _localizedValues[locale.languageCode]?['dueDate'] ?? 'Due Date';
  String get dueTime => _localizedValues[locale.languageCode]?['dueTime'] ?? 'Due Time';
  String get reminder => _localizedValues[locale.languageCode]?['reminder'] ?? 'Reminder';
  String get repeat => _localizedValues[locale.languageCode]?['repeat'] ?? 'Repeat';
  String get category => _localizedValues[locale.languageCode]?['category'] ?? 'Category';
  String get amount => _localizedValues[locale.languageCode]?['amount'] ?? 'Amount';
  String get note => _localizedValues[locale.languageCode]?['note'] ?? 'Note';
  String get date => _localizedValues[locale.languageCode]?['date'] ?? 'Date';
  String get time => _localizedValues[locale.languageCode]?['time'] ?? 'Time';
  String get statistics => _localizedValues[locale.languageCode]?['statistics'] ?? 'Statistics';
  String get trend => _localizedValues[locale.languageCode]?['trend'] ?? 'Trend';
  String get categoryBreakdown => _localizedValues[locale.languageCode]?['categoryBreakdown'] ?? 'Category Breakdown';
  String get recentTransactions => _localizedValues[locale.languageCode]?['recentTransactions'] ?? 'Recent Transactions';
  String get viewAll => _localizedValues[locale.languageCode]?['viewAll'] ?? 'View All';
  String get backup => _localizedValues[locale.languageCode]?['backup'] ?? 'Backup';
  String get restore => _localizedValues[locale.languageCode]?['restore'] ?? 'Restore';
  String get sync => _localizedValues[locale.languageCode]?['sync'] ?? 'Sync';
  String get theme => _localizedValues[locale.languageCode]?['theme'] ?? 'Theme';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get notification => _localizedValues[locale.languageCode]?['notification'] ?? 'Notification';
  String get security => _localizedValues[locale.languageCode]?['security'] ?? 'Security';
  String get about => _localizedValues[locale.languageCode]?['about'] ?? 'About';
  String get version => _localizedValues[locale.languageCode]?['version'] ?? 'Version';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get deleteAccount => _localizedValues[locale.languageCode]?['deleteAccount'] ?? 'Delete Account';
  String get welcome => _localizedValues[locale.languageCode]?['welcome'] ?? 'Welcome to LifeFlow';
  String get welcomeSubtitle => _localizedValues[locale.languageCode]?['welcomeSubtitle'] ?? 'Manage your life, record every moment';
  String get getStarted => _localizedValues[locale.languageCode]?['getStarted'] ?? 'Get Started';
  String get skip => _localizedValues[locale.languageCode]?['skip'] ?? 'Skip';
  String get next => _localizedValues[locale.languageCode]?['next'] ?? 'Next';
  String get finish => _localizedValues[locale.languageCode]?['finish'] ?? 'Finish';
  String get onboarding1Title => _localizedValues[locale.languageCode]?['onboarding1Title'] ?? 'Finance Management';
  String get onboarding1Desc => _localizedValues[locale.languageCode]?['onboarding1Desc'] ?? 'Track every income and expense, master your finances';
  String get onboarding2Title => _localizedValues[locale.languageCode]?['onboarding2Title'] ?? 'Journal Recording';
  String get onboarding2Desc => _localizedValues[locale.languageCode]?['onboarding2Desc'] ?? 'Record life moments, preserve beautiful memories';
  String get onboarding3Title => _localizedValues[locale.languageCode]?['onboarding3Title'] ?? 'Task Management';
  String get onboarding3Desc => _localizedValues[locale.languageCode]?['onboarding3Desc'] ?? 'Plan daily tasks, improve work efficiency';
  String get onboarding4Title => _localizedValues[locale.languageCode]?['onboarding4Title'] ?? 'Calendar Integration';
  String get onboarding4Desc => _localizedValues[locale.languageCode]?['onboarding4Desc'] ?? 'Unified schedule management, never miss important events';
}

class _AppLocalizationsDelegate extends LocalizationsDelegateDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
