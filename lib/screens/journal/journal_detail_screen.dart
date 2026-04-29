import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/mood_selector.dart';
import 'journal_edit_screen.dart';
import 'package:provider/provider.dart';

class JournalDetailScreen extends StatelessWidget {
  final String entryId;

  const JournalDetailScreen({
    Key? key,
    required this.entryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final entry = provider.getEntryById(entryId);

        if (entry == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('日记不存在')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(DateFormat('MM月dd日').format(entry.createdAt)),
            actions: _isToday(entry.createdAt) ? [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editEntry(context, entry),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteEntry(context, provider, entry),
              ),
            ] : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (entry.moodId != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: MoodSelector.getMoodColor(entry.moodId).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MoodSelector.getMoodEmoji(entry.moodId),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              MoodSelector.getMoodLabel(entry.moodId),
                              style: TextStyle(
                                color: MoodSelector.getMoodColor(entry.moodId),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (entry.isEncrypted)
                      const Icon(Icons.lock, size: 18, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  entry.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                if (entry.mediaUrls != null && entry.mediaUrls!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '图片',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: entry.mediaUrls!.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildMediaImage(entry.mediaUrls![index]),
                      );
                    },
                  ),
                ],
                if (entry.location != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(entry.location!),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  '创建于 ${DateFormat('yyyy年MM月dd日 HH:mm').format(entry.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                if (entry.updatedAt != entry.createdAt)
                  Text(
                    '更新于 ${DateFormat('yyyy年MM月dd日 HH:mm').format(entry.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editEntry(BuildContext context, JournalModel entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditScreen(entry: entry),
      ),
    );
  }

  Future<void> _deleteEntry(
    BuildContext context,
    JournalProvider provider,
    JournalModel entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这篇日记吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteEntry(entry.id);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildMediaImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(url, fit: BoxFit.cover);
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return const Center(child: Icon(Icons.broken_image));
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
