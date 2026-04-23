import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_manager/presentation/viewmodels/home_viewmodel.dart';
import 'package:personal_manager/presentation/widgets/common/app_drawer.dart';
import 'package:personal_manager/presentation/widgets/finance/balance_card.dart';
import 'package:personal_manager/presentation/widgets/finance/recent_transactions.dart';
import 'package:personal_manager/presentation/widgets/tasks/today_tasks.dart';
import 'package:personal_manager/presentation/widgets/journal/mood_summary.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 打开通知中心
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeViewModelProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 财务概览
              BalanceCard(
                totalBalance: homeState.totalBalance,
                monthlyIncome: homeState.monthlyIncome,
                monthlyExpense: homeState.monthlyExpense,
              ),
              const SizedBox(height: 24),

              // 今日任务
              TodayTasks(
                tasks: homeState.todayTasks,
                onTaskToggle: (taskId) {
                  ref.read(homeViewModelProvider.notifier).toggleTask(taskId);
                },
              ),
              const SizedBox(height: 24),

              // 心情摘要
              MoodSummary(
                todayMood: homeState.todayMood,
                streakDays: homeState.moodStreakDays,
              ),
              const SizedBox(height: 24),

              // 最近交易
              RecentTransactions(
                transactions: homeState.recentTransactions,
                onViewAll: () {
                  Navigator.pushNamed(context, '/finance');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickAddMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showQuickAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('记一笔'),
              subtitle: const Text('记录收入或支出'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/finance/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('写日记'),
              subtitle: const Text('记录今天的心情'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/journal/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('添加任务'),
              subtitle: const Text('创建新的待办事项'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tasks/add');
              },
            ),
          ],
        ),
      ),
    );
  }
}
