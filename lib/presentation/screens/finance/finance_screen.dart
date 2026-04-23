import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/finance_provider.dart';
import '../../providers/currency_provider.dart';
import 'widgets/transaction_list_item.dart';
import 'widgets/category_pie_chart.dart';
import 'add_transaction_screen.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerStateState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerStateState<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(
      monthlyTransactionsProvider(
        year: _selectedYear,
        month: _selectedMonth,
      ),
    );
    final summaryAsync = ref.watch(
      monthlySummaryProvider(
        year: _selectedYear,
        month: _selectedMonth,
      ),
    );
    final currencySymbol = ref.watch(currencySymbolProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(summaryAsync, currencySymbol),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '明细', icon: Icon(Icons.list)),
                  Tab(text: '图表', icon: Icon(Icons.pie_chart)),
                  Tab(text: '趋势', icon: Icon(Icons.trending_up)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTransactionList(transactionsAsync),
            _buildChartView(transactionsAsync),
            _buildTrendView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('记一笔'),
      ),
    );
  }

  Widget _buildHeader(AsyncSummary summary, String currencySymbol) {
    return summary.when(
      data: (data) => Container(
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMonthSelector(),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () => _showFilterSheet(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    '支出',
                    data.totalExpense,
                    Colors.red.shade300,
                    currencySymbol,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    '收入',
                    data.totalIncome,
                    Colors.green.shade300,
                    currencySymbol,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '结余',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$currencySymbol${data.balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: data.balance >= 0 ? Colors.green.shade200 : Colors.red.shade200,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }

  Widget _buildMonthSelector() {
    return GestureDetector(
      onTap: () => _showMonthPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_selectedYear年$_selectedMonth月',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    String currencySymbol,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$currencySymbol${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(AsyncTransactions transactions) {
    return transactions.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无记录', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // Group by date
        final grouped = <DateTime, List List<Transaction>>{};
        for (final t in list) {
          final date = DateTime(t.timestamp.year, t.timestamp.month, t.timestamp.day);
          grouped.putIfAbsent(date, () => []).add(t);
        }

        final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final dayTransactions = grouped[date]!;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MM月dd日 EEEE', 'zh_CN').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      _buildDayTotal(dayTransactions),
                    ],
                  ),
                ),
                ...dayTransactions.map((t) => TransactionListItem(
                  transaction: t,
                  onTap: () => _showTransactionDetail(t),
                  onLongPress: () => _showTransactionOptions(t),
                )),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }

  Widget _buildDayTotal(List(List<Transaction> transactions) {
    double income = 0;
    double expense = 0;
    
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    return Row(
      children: [
        if (income > 0)
          Text(
            '+${income.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
            ),
          ),
        if (expense > 0)
          Text(
            '-${expense.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildChartView(AsyncTransactions transactions) {
    return transactions.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }

        final expenses = list.where((t) => t.type == TransactionType.expense).toList();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CategoryPieChart(transactions: expenses),
              const SizedBox(height: 24),
              _buildCategoryList(expenses),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }

  Widget _buildCategoryList(List(List<Transaction> expenses) {
    final categoryMap = <String, double>{};
    for (final t in expenses) {
      categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
    }

    final sortedCategories = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = expenses.fold<double>(0, (sum, t) => sum + t.amount);

    return Column(
      children: sortedCategories.map((entry) {
        final percentage = total > 0 ? (entry.value / total * 100) : 0;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getCategoryColor(entry.key).withOpacity(0.2),
            child: Icon(
              _getCategoryIcon(entry.key),
              color: _getCategoryColor(entry.key),
              size: 20,
            ),
          ),
          title: Text(entry.key),
          subtitle: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(_getCategoryColor(entry.key)),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.value.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendView() {
    // TODO: Implement trend chart
    return const Center(child: Text('趋势分析开发中...'));
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '选择月份',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.5,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == _selectedMonth;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedMonth = month);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$month月',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    // TODO: Implement filter
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionScreen(),
    );
  }

  void _showTransactionDetail(Transaction transaction) {
    // TODO: Show detail
  }

  void _showTransactionOptions(Transaction transaction) {
    // TODO: Show options (edit/delete)
  }

  Color _getCategoryColor(String category) {
    final colors = {
      '餐饮': Colors.orange,
      '交通': Colors.blue,
      '购物': Colors.pink,
      '娱乐': Colors.purple,
      '医疗': Colors.red,
      '教育': Colors.green,
      '住房': Colors.brown,
      '其他': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    final icons = {
      '餐饮': Icons.restaurant,
      '交通': Icons.directions_car,
      '购物': Icons.shopping_bag,
      '娱乐': Icons.movie,
      '医疗': Icons.local_hospital,
      '教育': Icons.school,
      '住房': Icons.home,
      '其他': Icons.more_horiz,
    };
    return icons[category] ?? Icons.category;
  }
}
