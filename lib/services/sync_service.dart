import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sync_config.dart';
import 'database_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Timer? _syncTimer;
  bool _isSyncing = false;
  final DatabaseService _databaseService = DatabaseService();

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
    if (config.serverUrl == null || config.username == null || config.password == null) {
      return false;
    }

    try {
      // 导出本地数据
      final exportJson = await exportData();

      // 上传数据到服务器
      final uploadResponse = await http.put(
        Uri.parse('${config.serverUrl}/lifeflow_backup.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.password}'))}',
          'Content-Type': 'application/json',
        },
        body: exportJson,
      );

      if (uploadResponse.statusCode != 200 && uploadResponse.statusCode != 201) {
        print('Upload failed: ${uploadResponse.statusCode}');
        return false;
      }

      // 下载服务器数据
      final downloadResponse = await http.get(
        Uri.parse('${config.serverUrl}/lifeflow_backup.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${config.username}:${config.password}'))}',
        },
      );

      if (downloadResponse.statusCode == 200) {
        final success = await importData(downloadResponse.body);
        if (!success) {
          print('Failed to import server data');
        }
      }

      return true;
    } catch (e) {
      print('WebDAV sync error: $e');
      return false;
    }
  }

  // 导出数据
  Future<String> exportData() async {
    final data = await _databaseService.exportData();
    final exportData = {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'data': data,
    };

    return jsonEncode(exportData);
  }

  // 导入数据
  Future<bool> importData(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // 验证版本兼容性
      final version = decoded['version'] as String?;
      if (version == null) return false;

      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) return false;

      await _databaseService.importData(data);
      return true;
    } catch (e) {
      print('Import error: $e');
      return false;
    }
  }

  bool get isSyncing => _isSyncing;
}
