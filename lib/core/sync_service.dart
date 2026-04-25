import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sync_config.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Timer? _syncTimer;
  bool _isSyncing = false;

  // WebDAV 配置 - TODO: 实现同步功能时使用
  // String? _webdavUrl;
  // String? _webdavUsername;
  // String? _webdavPassword;

  // iCloud 配置 - TODO: 实现同步功能时使用
  // bool _icloudEnabled = false;

  void startAutoSync(SyncConfig config, Function onSync) {
    _syncTimer?.cancel();
    
    if (!config.autoSync) return;

    Duration interval;
    switch (config.syncInterval) {
      case '15min':
        interval = const Duration(minutes: 15);
        break;
      case '1hour':
        interval = const Duration(hours: 1);
        break;
      case 'daily':
      default:
        interval = const Duration(days: 1);
        break;
    }

    _syncTimer = Timer.periodic(interval, (_) async {
      await performSync(config);
      onSync();
    });
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<bool> performSync(SyncConfig config) async {
    if (_isSyncing) return false;
    _isSyncing = true;

    try {
      switch (config.provider) {
        case 'iCloud':
          return await _syncToiCloud();
        case 'WebDAV':
          return await _syncToWebDAV(config);
        case 'local':
        default:
          return true;
      }
    } catch (e) {
      print('Sync error: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _syncToiCloud() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> _syncToWebDAV(SyncConfig config) async {
    if (config.serverUrl == null) return false;

    try {
      final response = await http.put(
        Uri.parse('${config.serverUrl}/lifeflow_backup.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.password}'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('WebDAV sync error: $e');
      return false;
    }
  }

  bool get isSyncing => _isSyncing;
}
