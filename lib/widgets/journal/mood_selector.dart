import 'package:flutter/material.dart';

class Mood {
  final int id;
  final String emoji;
  final String label;
  final Color color;

  const Mood({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
  });
}

class MoodSelector extends StatelessWidget {
  final int? selectedMoodId;
  final Function(int?) onMoodSelected;

  const MoodSelector({
    Key? key,
    this.selectedMoodId,
    required this.onMoodSelected,
  }) : super(key: key);

  static const List<Mood> moods = [
    Mood(id: 1, emoji: '😄', label: '开心', color: Colors.orange),
    Mood(id: 2, emoji: '😊', label: '满足', color: Colors.yellow),
    Mood(id: 3, emoji: '😐', label: '平静', color: Colors.blue),
    Mood(id: 4, emoji: '😔', label: '低落', color: Colors.grey),
    Mood(id: 5, emoji: '😤', label: '生气', color: Colors.red),
    Mood(id: 6, emoji: '😰', label: '焦虑', color: Colors.purple),
    Mood(id: 7, emoji: '😴', label: '疲惫', color: Colors.indigo),
    Mood(id: 8, emoji: '🤗', label: '感恩', color: Colors.pink),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: moods.map((mood) {
        final isSelected = selectedMoodId == mood.id;
        return InkWell(
          onTap: () => onMoodSelected(isSelected ? null : mood.id),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? mood.color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                ? Border.all(color: mood.color, width: 2)
                : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? mood.color : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static String getMoodEmoji(int? moodId) {
    if (moodId == null) return '';
    try {
      return moods.firstWhere((m) => m.id == moodId).emoji;
    } catch (e) {
      return '';
    }
  }

  static String getMoodLabel(int? moodId) {
    if (moodId == null) return '';
    try {
      return moods.firstWhere((m) => m.id == moodId).label;
    } catch (e) {
      return '';
    }
  }

  static Color getMoodColor(int? moodId) {
    if (moodId == null) return Colors.grey;
    try {
      return moods.firstWhere((m) => m.id == moodId).color;
    } catch (e) {
      return Colors.grey;
    }
  }
}
