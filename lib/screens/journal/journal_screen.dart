import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/journal_card.dart';
import '../../widgets/common/empty_state.dart';
import 'journal_edit_screen.dart';
import 'journal_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<JournalProvider>().loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = context.watch<JournalProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('日记'),
        actions: [
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                });
                context.read<JournalProvider>().loadEntries();
              },
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to journal search
            },
          ),
        ],
      ),
      body: journalProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : journalProvider.entries.isEmpty
              ? EmptyState(
                  icon: Icons.book_outlined,
                  title: '暂无日记',
                  subtitle: '开始记录今天的故事吧',
                  actionLabel: '写日记',
                  onAction: () => _navigateToEditor(context),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await context.read<JournalProvider>().loadEntries();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: journalProvider.entries.length,
                    itemBuilder: (context, index) {
                      final entry = journalProvider.entries[index];
                      return JournalCard(
                        entry: entry,
                        onTap: () => _navigateToDetail(context, entry),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(context),
        icon: const Icon(Icons.edit),
        label: const Text('写作'),
      ),
    );
  }

  void _navigateToEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalEditScreen()),
    ).then((_) async {
      await context.read<JournalProvider>().loadEntries();
      if (context.mounted) {
        setState(() {});
      }
    });
  }

  void _navigateToDetail(BuildContext context, JournalModel entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailScreen(entryId: entry.id),
      ),
    ).then((_) async {
      await context.read<JournalProvider>().loadEntries();
      if (context.mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      final startDate = DateTime(date.year, date.month, date.day);
      final endDate = startDate.add(const Duration(days: 1));
      await context.read<JournalProvider>().loadEntries(
        startDate: startDate,
        endDate: endDate,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }
}
