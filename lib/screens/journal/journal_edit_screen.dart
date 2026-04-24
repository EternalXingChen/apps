import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/journal/mood_selector.dart';
import 'package:provider/provider.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalModel? entry;

  const JournalEditScreen({Key? key, this.entry}) : super(key: key);

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();
  int? _selectedMoodId;
  bool _isEncrypted = false;
  List<String> _mediaUrls = [];

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _contentController.text = widget.entry!.content;
      _locationController.text = widget.entry!.location ?? '';
      _selectedMoodId = widget.entry!.moodId;
      _isEncrypted = widget.entry!.isEncrypted;
      _mediaUrls = widget.entry!.mediaUrls ?? [];
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入日记内容')),
      );
      return;
    }

    final entry = JournalModel(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: _contentController.text.trim(),
      moodId: _selectedMoodId,
      mediaUrls: _mediaUrls.isNotEmpty ? _mediaUrls : null,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      isEncrypted: _isEncrypted,
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<JournalProvider>();

    if (_isEditing) {
      await provider.updateEntry(entry);
    } else {
      await provider.addEntry(entry);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑日记' : '写日记'),
        actions: [
          IconButton(
            icon: Icon(_isEncrypted ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _isEncrypted = !_isEncrypted;
              });
            },
          ),
          TextButton(
            onPressed: _saveEntry,
            child: const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今天感觉如何？',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            MoodSelector(
              selectedMoodId: _selectedMoodId,
              onMoodSelected: (moodId) {
                setState(() {
                  _selectedMoodId = moodId;
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              '记录你的想法',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '写下今天发生的事情、感受...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '位置（可选）',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: '添加位置信息',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_mediaUrls.isNotEmpty) ...[
              Text(
                '图片',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _mediaUrls.map((url) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _mediaUrls.remove(url);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement image picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('图片选择功能待实现')),
                );
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('添加图片'),
            ),
          ],
        ),
      ),
    );
  }
}
