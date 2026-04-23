import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> data;

  const ExpenseChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          '暂无数据',
          style: TextStyle(
            color: LifeFlowColors.textSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    final colors = [
      const Color(0xFF4A90E2),
      const Color(0xFF5AC8FA),
      const Color(0xFF34C759),
      const Color(0xFFFF9500),
      const Color(0xFFFF3B30),
      const Color(0xFFAF52DE),
      const Color(0xFF5856D6),
      const Color(0xFFFF2D55),
    ];

    final total = data.values.fold<double>(0, (sum, value) => sum + value);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: data.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value.key;
                final value = entry.value.value;
                final percentage = (value / total * 100).toStringAsFixed(1);

                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: value,
                  title: '$percentage%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value.key;
            final value = entry.value.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: LifeFlowColors.textSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
