import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import 'package:provider/provider.dart' show Consumer2, ReadContext;

class FinanceStatsScreen extends StatefulWidget {
  const FinanceStatsScreen({Key? key}) : super(key: key);

  @override
  State<FinanceStatsScreen> createState() => _FinanceStatsScreenState();
}

class _FinanceStatsScreenState extends State<FinanceStatsScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final transactionProvider = context.read<TransactionProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    
    await transactionProvider.loadTransactions(
      startDate: DateTime(_selectedYear, _selectedMonth, 1),
      endDate: DateTime(_selectedYear, _selectedMonth + 1, 0),
    );
    await categoryProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收支统计'),
      ),
      body: Consumer2<TransactionProvider, CategoryProvider>(
        builder: (context, transactionProvider, categoryProvider, child) {
          if (transactionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final categoryTotals = transactionProvider.getCategoryTotals();
          final totalExpense = transactionProvider.totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          if (_selectedMonth == 1) {
                            _selectedMonth = 12;
                            _selectedYear--;
                          } else {
                            _selectedMonth--;
                          }
                        });
                        _loadData();
                      },
                    ),
                    Text(
                      '$_selectedYear年$_selectedMonth月',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          if (_selectedMonth == 12) {
                            _selectedMonth = 1;
                            _selectedYear++;
                          } else {
                            _selectedMonth++;
                          }
                        });
                        _loadData();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        '收入',
                        transactionProvider.totalIncome,
                        Colors.green,
                        Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        '支出',
                        transactionProvider.totalExpense,
                        Colors.red,
                        Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context,
                  '结余',
                  transactionProvider.balance,
                  transactionProvider.balance >= 0 ? Colors.blue : Colors.orange,
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 32),

                // Pie chart
                if (categoryTotals.isNotEmpty) ...[
                  Text(
                    '支出分类',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildPieSections(categoryTotals, totalExpense, categoryProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: categoryTotals.entries.map((entry) {
                      final category = categoryProvider.getCategoryById(entry.key);
                      final percentage = totalExpense > 0
                          ? (entry.value / totalExpense * 100).toStringAsFixed(1)
                          : '0.0';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('${category?.icon ?? "📦"} ${category?.name ?? "未知"}'),
                          const SizedBox(width: 4),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '¥${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
    Map<String, double> categoryTotals,
    double total,
    CategoryProvider categoryProvider,
  ) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    int colorIndex = 0;
    return categoryTotals.entries.map((entry) {
      final percentage = total > 0 ? entry.value / total : 0;
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String categoryId) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[categoryId.hashCode % colors.length];
  }
}
