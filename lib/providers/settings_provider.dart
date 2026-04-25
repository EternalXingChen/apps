import 'package:flutter/foundation.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  String _calendarLocale = 'zh_CN';

  String get calendarLocale => _calendarLocale;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final locale = await _db.getSetting('calendar_locale');
    if (locale != null) {
      _calendarLocale = locale;
      notifyListeners();
    }
  }

  Future<void> setCalendarLocale(String locale) async {
    _calendarLocale = locale;
    await _db.setSetting('calendar_locale', locale);
    notifyListeners();
  }
}
