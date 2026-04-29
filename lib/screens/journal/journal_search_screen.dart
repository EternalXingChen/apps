import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import 'journal_detail_screen.dart';

class JournalSearchScreen extends StatefulWidget {
  const JournalSearchScreen({Key? key}) : super(key: key);

  @override
  State<JournalSearchScreen> createState() => _JournalSearchScreenState();
}

class _JournalSearchScreenState extends State<JournalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JournalProvider>();
      if (provider.entries.isEmpty) {
        provider.loadEntries();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JournalModel> _filterEntries(List<JournalModel> entries) {
    if (_query.isEmpty) {
      return entries;
    }
    final lower = _query.toLowerCase();
    return entries.where((entry) {
      final content = entry.content.toLowerCase();
      final location = entry.location?.toLowerCase() ?? '';
      return content.contains(lower) || location.contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JournalProvider>();
    final entries = _filterEntries(provider.entries);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '搜索日记内容、位置',
            border: InputBorder.none,
          ),
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(child: Text('暂无匹配的日记'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          entry.content.length > 40
                              ? '${entry.content.substring(0, 40)}...'
                              : entry.content,
                        ),
                        subtitle: Text(entry.location ?? '无位置'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JournalDetailScreen(entryId: entry.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
