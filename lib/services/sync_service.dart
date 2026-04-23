import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sync_config.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Timer? _syncTimer;
  bool _isSyncing = false;

  // 开始自动同步
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

  // 停止自动同步
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // 执行同步
  Future<bool> performSync(SyncConfig config) async {
    if (_isSyncing) return false;
    _isSyncing = true;

    try {
      switch (config.provider) {
        case 'iCloud':
          return await _syncToiCloud(config);
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

  // iCloud 同步
  Future<bool> _syncToiCloud(SyncConfig config) async {
    // 实际实现需要使用 iCloud Kit
    // 这里仅作示例
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  // WebDAV 同步
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

  // 导出数据
  Future<String> exportData(Map<String, dynamic> data) async {
    final exportData = {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'data': data,
    };

    return jsonEncode(exportData);
  }

  // 导入数据
  Future<Map<String, dynamic>?> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // 验证版本兼容性
      final version = data['version'] as String?;
      if (version == null) return null;

      return data['data'] as Map<String, dynamic>?;
    } catch (e) {
      print('Import error: $e');
      return null;
    }
  }

  bool get isSyncing => _isSyncing;
}
