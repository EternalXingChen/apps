import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MoodSelector extends StatefulWidget {
  final int? selectedMoodId;
  final Function(int) onMoodSelected;

  const MoodSelector({
    Key? key,
    this.selectedMoodId,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  final List<Map<String, dynamic>> _moods = [
    {'id': 1, 'emoji': '😊', 'label': '开心', 'color': Color(0xFFFFD93D)},
    {'id': 2, 'emoji': '😢', 'label': '难过', 'color': Color(0xFF6BCB77)},
    {'id': 3, 'emoji': '😠', 'label': '生气', 'color': Color(0xFFFF6B6B)},
    {'id': 4, 'emoji': '😰', 'label': '焦虑', 'color': Color(0xFF4D96FF)},
    {'id': 5, 'emoji': '😐', 'label': '平静', 'color': Color(0xFF9B9B9B)},
    {'id': 6, 'emoji': '🤩', 'label': '兴奋', 'color': Color(0xFFFF9F45)},
    {'id': 7, 'emoji': '😴', 'label': '疲惫', 'color': Color(0xFF6C5CE7)},
    {'id': 8, 'emoji': '🥰', 'label': '幸福', 'color': Color(0xFFFF6B9D)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '此刻心情',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _moods.map((mood) {
              final isSelected = widget.selectedMoodId == mood['id'];
              return GestureDetector(
                onTap: () => widget.onMoodSelected(mood['id'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (mood['color'] as Color).withOpacity(0.2)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? mood['color'] as Color
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? mood['color'] as Color
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
