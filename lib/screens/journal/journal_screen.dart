import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/journal_entry.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/journal_card.dart';
import '../../widgets/common/empty_state.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerStateState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerStateState<JournalScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(journalProvider.notifier).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final journalState = ref.watch(journalProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.journal),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              context.push('/journal/calendar');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/journal/search');
            },
          ),
        ],
      ),
      body: journalState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : journalState.entries.isEmpty
              ? EmptyState(
                  icon: Icons.book_outlined,
                  title: l10n.noJournalEntries,
                  subtitle: l10n.startWritingToday,
                  actionLabel: l10n.writeJournal,
                  onAction: () => _navigateToEditor(context),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(journalProvider.notifier).loadEntries();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: journalState.entries.length,
                    itemBuilder: (context, index) {
                      final entry = journalState.entries[index];
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
        label: Text(l10n.write),
      ),
    );
  }

  void _navigateToEditor(BuildContext context) {
    context.push('/journal/edit');
  }

  void _navigateToDetail(BuildContext context, JournalEntry entry) {
    context.push('/journal/detail/${entry.id}');
  }
}
