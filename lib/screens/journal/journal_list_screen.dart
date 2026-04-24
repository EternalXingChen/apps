import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/journal_entry.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/journal_card.dart';
import 'journal_edit_screen.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('日记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, ref);
            },
          ),
        ],
      ),
      body: journalState.when(
        data: (entries) {
          if (entries.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildJournalList(context, ref, entries);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewEntry(context),
        icon: const Icon(Icons.add),
        label: const Text('写日记'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '开始记录你的生活',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '写日记可以帮助你整理思绪，记录美好时光',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _createNewEntry(context),
            icon: const Icon(Icons.edit),
            label: const Text('写第一篇日记'),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList(
    BuildContext context,
    WidgetRef ref,
    List<JournalEntry> entries,
  ) {
    // 按日期分组
    final groupedEntries = _groupEntriesByDate(entries);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedEntries.length,
      itemBuilder: (context, index) {
        final group = groupedEntries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期标题
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                group.date,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            // 日记卡片
            ...group.entries.map((entry) => JournalCard(
                  entry: entry,
                  onTap: () => _viewEntry(context, entry),
                  onEdit: () => _editEntry(context, entry),
                  onDelete: () => _deleteEntry(context, ref, entry),
                )),
          ],
        );
      },
    );
  }

  List<JournalGroup> _groupEntriesByDate(List(List<JournalEntry> entries) {
    final groups = <String, List<JournalEntry>>{};

    for (final entry in entries) {
      final date = _formatDate(entry.createdAt);
      groups.putIfAbsent(date, () => []).add(entry);
    }

    return groups.entries
        .map((e) => JournalGroup(date: e.key, entries: e.value))
        .toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return '今天';
    } else if (entryDate == yesterday) {
      return '昨天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  void _createNewEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalEditScreen(),
      ),
    );
  }

  void _viewEntry(BuildContext context, JournalEntry entry) {
    // TODO: 实现查看详情
  }

  void _editEntry(BuildContext context, JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditScreen(entry: entry),
      ),
    );
  }

  void _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除日记'),
        content: const Text('确定要删除这篇日记吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(journalProvider.notifier).deleteEntry(entry.id);
              Navigator.pop(context);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    // TODO: 实现筛选对话框
  }
}

class JournalGroup {
  final String date;
  final List<JournalEntry> entries;

  JournalGroup({required this.date, required this.entries});
}
