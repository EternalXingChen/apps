import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  String _calendarLocale = 'zh_CN';
  String _appLocale = 'zh_CN';
  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;

  String get calendarLocale => _calendarLocale;
  String get appLocale => _appLocale;
  bool get notificationsEnabled => _notificationsEnabled;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _appLocale == 'en_US'
      ? const Locale('en', 'US')
      : const Locale('zh', 'CN');

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final calendarLocale = await _db.getSetting('calendar_locale');
    if (calendarLocale != null) {
      _calendarLocale = calendarLocale;
    }

    final appLocale = await _db.getSetting('app_locale');
    if (appLocale != null) {
      _appLocale = appLocale;
    }

    final notifications = await _db.getSetting('notifications_enabled');
    if (notifications != null) {
      _notificationsEnabled = notifications == 'true';
    }

    final themeMode = await _db.getSetting('theme_mode');
    if (themeMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setCalendarLocale(String locale) async {
    _calendarLocale = locale;
    await _db.setSetting('calendar_locale', locale);
    notifyListeners();
  }

  Future<void> setAppLocale(String locale) async {
    _appLocale = locale;
    await _db.setSetting('app_locale', locale);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _db.setSetting('notifications_enabled', enabled ? 'true' : 'false');
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _db.setSetting('theme_mode',
        mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.light ? 'light' : 'system');
    notifyListeners();
  }
}
