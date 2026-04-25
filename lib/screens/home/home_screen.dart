import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/transaction_provider.dart';
import '../finance/finance_screen.dart';
import '../finance/transaction_edit_screen.dart';
import '../journal/journal_screen.dart';
import '../journal/journal_edit_screen.dart';
import '../tasks/task_list_screen.dart';
import '../tasks/task_edit_screen.dart';
import '../calendar/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardView(),
    const FinanceScreen(),
    const JournalScreen(),
    const TaskListScreen(),
    const CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, '首页', 0),
                _buildNavItem(Icons.account_balance_wallet_rounded, '财务', 1),
                _buildNavItem(Icons.edit_note_rounded, '日记', 2),
                _buildNavItem(Icons.check_circle_outline_rounded, '任务', 3),
                _buildNavItem(Icons.calendar_today_rounded, '日历', 4),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_currentIndex == 0) return null;
    
    IconData icon;
    VoidCallback onPressed;
    
    switch (_currentIndex) {
      case 1:
        icon = Icons.add_card_rounded;
        onPressed = () => _showAddTransactionDialog();
        break;
      case 2:
        icon = Icons.edit_rounded;
        onPressed = () => _showAddJournalDialog();
        break;
      case 3:
        icon = Icons.add_task_rounded;
        onPressed = () => _showAddTaskDialog();
        break;
      case 4:
        icon = Icons.add_rounded;
        onPressed = () => _showAddEventDialog();
        break;
      default:
        return null;
    }
    
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryColor,
      child: Icon(icon, color: Colors.grey.shade100),
    );
  }

  void _showAddTransactionDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionEditScreen(),
      ),
    ).then((_) async {
      // Always refresh data when returning from any screen
      final taskProvider = context.read<TaskProvider>();
      final journalProvider = context.read<JournalProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      await Future.wait([
        taskProvider.loadTasks(),
        journalProvider.loadEntries(),
        transactionProvider.loadTransactions(),
      ]);

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showAddJournalDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalEditScreen(),
      ),
    ).then((_) async {
      // Always refresh data when returning from any screen
      final taskProvider = context.read<TaskProvider>();
      final journalProvider = context.read<JournalProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      await Future.wait([
        taskProvider.loadTasks(),
        journalProvider.loadEntries(),
        transactionProvider.loadTransactions(),
      ]);

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showAddTaskDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskEditScreen(),
      ),
    ).then((_) async {
      // Always refresh data when returning from any screen
      final taskProvider = context.read<TaskProvider>();
      final journalProvider = context.read<JournalProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      await Future.wait([
        taskProvider.loadTasks(),
        journalProvider.loadEntries(),
        transactionProvider.loadTransactions(),
      ]);

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showAddEventDialog() {
    // Calendar screen already has its own FAB for adding events
    // Navigate to calendar tab
    setState(() => _currentIndex = 4);
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final taskProvider = context.read<TaskProvider>();
    final journalProvider = context.read<JournalProvider>();
    final transactionProvider = context.read<TransactionProvider>();

    await Future.wait([
      taskProvider.loadTasks(),
      journalProvider.loadEntries(),
      transactionProvider.loadTransactions(),
    ]);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildTodayOverview(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildRecentActivity(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '早上好 👋',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'LifeFlow',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayOverview() {
    return Consumer3<TransactionProvider, JournalProvider, TaskProvider>(
      builder: (context, transactionProvider, journalProvider, taskProvider, child) {
        final today = DateTime.now();
        final todayTransactions = transactionProvider.transactions.where((t) {
          return t.timestamp.year == today.year &&
                 t.timestamp.month == today.month &&
                 t.timestamp.day == today.day;
        }).toList();
        
        final todayExpense = todayTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);
        
        final todayJournals = journalProvider.entries.where((j) {
          return j.createdAt.year == today.year &&
                 j.createdAt.month == today.month &&
                 j.createdAt.day == today.day;
        }).toList();
        
        final todayTasks = taskProvider.tasks.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.year == today.year &&
                 t.dueDate!.month == today.month &&
                 t.dueDate!.day == today.day;
        }).toList();
        
        final completedTasks = todayTasks.where((t) => t.isCompleted).length;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '今日概览',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToFinance(),
                      child: _buildOverviewItem(
                        '💰',
                        '今日支出',
                        '¥${todayExpense.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToJournal(),
                      child: _buildOverviewItem(
                        '📝',
                        '日记',
                        '${todayJournals.length}篇',
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToTasks(),
                      child: _buildOverviewItem(
                        '✅',
                        '待办',
                        '$completedTasks/${todayTasks.length}',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快速操作',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                '记一笔',
                Icons.add_card_rounded,
                AppTheme.primaryColor,
                () => _navigateToAddTransaction(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                '写日记',
                Icons.edit_note_rounded,
                AppTheme.secondaryColor,
                () => _navigateToAddJournal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                '新任务',
                Icons.add_task_rounded,
                AppTheme.secondaryColor,
                () => _navigateToAddTask(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionEditScreen(),
      ),
    ).then((_) async {
      await _loadData();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _navigateToAddJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalEditScreen(),
      ),
    ).then((_) async {
      await _loadData();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskEditScreen(),
      ),
    ).then((_) async {
      await _loadData();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _navigateToFinance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FinanceScreen(),
      ),
    ).then((_) => _loadData());
  }

  void _navigateToJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalScreen(),
      ),
    ).then((_) => _loadData());
  }

  void _navigateToTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskListScreen(),
      ),
    ).then((_) => _loadData());
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '最近动态',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('查看全部'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRecentActivityList(),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    return Consumer3<TransactionProvider, JournalProvider, TaskProvider>(
      builder: (context, transactionProvider, journalProvider, taskProvider, child) {
        // Combine all activities and sort by date
        final activities = <Map<String, dynamic>>[];

        // Add transactions
        for (var t in transactionProvider.transactions.take(5)) {
          activities.add({
            'type': 'transaction',
            'emoji': t.type == TransactionType.expense ? '💰' : '💵',
            'title': t.category,
            'category': t.type == TransactionType.expense ? '支出' : '收入',
            'amount': t.type == TransactionType.expense 
                ? '-¥${t.amount.toStringAsFixed(2)}' 
                : '+¥${t.amount.toStringAsFixed(2)}',
            'time': t.timestamp,
            'isExpense': t.type == TransactionType.expense,
          });
        }

        // Add journals
        for (var j in journalProvider.entries.take(5)) {
          activities.add({
            'type': 'journal',
            'emoji': '📝',
            'title': j.content.length > 20 
                ? '${j.content.substring(0, 20)}...' 
                : j.content,
            'category': '日记',
            'amount': '',
            'time': j.createdAt,
            'isExpense': false,
          });
        }

        // Add tasks
        for (var t in taskProvider.tasks.where((t) => t.isCompleted).take(5)) {
          activities.add({
            'type': 'task',
            'emoji': '✅',
            'title': t.title,
            'category': '任务',
            'amount': '',
            'time': t.updatedAt ?? t.createdAt,
            'isExpense': false,
          });
        }

        // Sort by time (newest first)
        activities.sort((a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));

        // Take top 5
        final recentActivities = activities.take(5).toList();

        if (recentActivities.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '暂无动态',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: recentActivities.map((activity) {
            return _buildActivityItem(
              activity['emoji'] as String,
              activity['title'] as String,
              activity['category'] as String,
              activity['amount'] as String,
              _formatTime(activity['time'] as DateTime),
              isExpense: activity['isExpense'] as bool,
            );
          }).toList(),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final activityDate = DateTime(time.year, time.month, time.day);

    if (activityDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (activityDate == yesterday) {
      return '昨天';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  Widget _buildActivityItem(
    String emoji,
    String title,
    String category,
    String amount,
    String time, {
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$category · $time',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (amount.isNotEmpty)
            Text(
              amount,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isExpense ? Colors.red : Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
