import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/journal_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../l10n/app_localizations.dart';
import 'journal_edit_screen.dart';
import 'journal_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State State<JournalScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read.read<JournalProvider>().loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = context.watch.watch<JournalProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.journal ?? '日记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Navigate to journal calendar
            },
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
                  title: l10n?.noJournalEntries ?? '暂无日记',
                  subtitle: l10n?.startWritingToday ?? '开始记录今天的故事吧',
                  actionLabel: l10n?.writeJournal ?? '写日记',
                  onAction: () => _navigateToEditor(context),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await context.read.read<JournalProvider>().loadEntries();
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
        label: Text(l10n?.write ?? '写作'),
      ),
    );
  }

  void _navigateToEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalEditScreen()),
    );
  }

  void _navigateToDetail(BuildContext context, JournalModel entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailScreen(entryId: entry.id),
      ),
    );
  }
}
