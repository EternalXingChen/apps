import 'package:flutter/foundation.dart';
import '../models/journal_model.dart';
import '../services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List List<JournalModel> _entries = [];
  bool _isLoading = false;
  String? _error;
  JournalModel? _selectedEntry;

  List List<JournalModel> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  JournalModel? get selectedEntry => _selectedEntry;

  Future<void> loadEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? moodId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await _db.getJournals(
        startDate: startDate,
        endDate: endDate,
        moodId: moodId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(JournalModel entry) async {
    try {
      await _db.insertJournal(entry);
      await loadEntries();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateEntry(JournalModel entry) async {
    try {
      final db = await _db.database;
      await db.update(
        'journals',
        entry.toJson(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
      await loadEntries();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final db = await _db.database;
      await db.delete('journals', where: 'id = ?', whereArgs: [id]);
      await loadEntries();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectEntry(JournalModel? entry) {
    _selectedEntry = entry;
    notifyListeners();
  }

  List List<JournalModel> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.createdAt.year == date.year &&
             entry.createdAt.month == date.month &&
             entry.createdAt.day == date.day;
    }).toList();
  }

  Map<int, int> getMoodDistribution() {
    final Map<int, int> distribution = {};
    for (var entry in _entries) {
      if (entry.moodId != null) {
        distribution[entry.moodId!] = (distribution[entry.moodId!] ?? 0) + 1;
      }
    }
    return distribution;
  }

  JournalModel? getEntryById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
