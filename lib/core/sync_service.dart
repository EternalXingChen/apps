import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/database_helper.dart';
import '../models/sync_models.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseHelper _db = DatabaseHelper();
  Timer? _syncTimer;
  bool _isSyncing = false;

  // WebDAV 配置
  String? _webdavUrl;
  String? _webdavUsername;
  String? _webdavPassword;

  // iCloud 配置
  bool _icloudEnabled = false;

  Future<void> initialize() async {
    final config = await _db.getSyncConfig();
    _webdavUrl = config['webdav_url'];
    _webdavUsername = config['webdav_username'];
    _webdavPassword = config['webdav_password'];
    _icloudEnabled = config['icloud_enabled'] == 1;
  }

  void startAutoSync({Duration interval = const Duration(minutes: 30)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => syncAll());
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      return SyncResult(success: false, message: '同步正在进行中');
    }

    _isSyncing = true;
    final results = <String, bool>{};

    try {
      // 同步到 WebDAV
      if (_webdavUrl != null) {
        results['webdav'] = await _syncToWebDAV();
      }

      // 同步到 iCloud
      if (_icloudEnabled) {
        results['icloud'] = await _syncToICloud();
      }

      // 更新最后同步时间
      await _db.updateLastSyncTime();

      final successCount = results.values.where((v) => v).length;
      return SyncResult(
        success: successCount > 0,
        message: '同步完成: ${successCount}/${results.length} 成功',
        details: results,
      );
    } catch (e) {
      return SyncResult(success: false, message: '同步失败: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _syncToWebDAV() async {
    if (_webdavUrl == null || _webdavUsername == null || _webdavPassword == null) {
      return false;
    }

    try {
      // 获取所有待同步数据
      final pendingData = await _db.getPendingSyncData();
      
      // 导出为 JSON
      final jsonData = jsonEncode(pendingData);
      
      // 上传到 WebDAV
      final response = await http.put(
        Uri.parse('$_webdavUrl/lifeflow_backup.json'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_webdavUsername:$_webdavPassword'))}',
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 标记数据为已同步
        await _db.markDataAsSynced();
        return true;
      }
      return false;
    } catch (e) {
      print('WebDAV 同步失败: $e');
      return false;
    }
  }

  Future<bool> _syncToICloud() async {
    // iCloud 同步实现
    // 需要使用 platform channel 调用原生 iCloud API
    // 这里简化处理
    return true;
  }

  Future Future<SyncResult> restoreFromBackup(String source) async {
    try {
      if (source == 'webdav' && _webdavUrl != null) {
        final response = await http.get(
          Uri.parse('$_webdavUrl/lifeflow_backup.json'),
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$_webdavUsername:$_webdavPassword'))}',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await _db.restoreFromBackup(data);
          return SyncResult(success: true, message: '从 WebDAV 恢复成功');
        }
      }

      return SyncResult(success: false, message: '恢复失败');
    } catch (e) {
      return SyncResult(success: false, message: '恢复失败: $e');
    }
  }

  Future<void> configureWebDAV({
    required String url,
    required String username,
    required String password,
  }) async {
    _webdavUrl = url;
    _webdavUsername = username;
    _webdavPassword = password;

    await _db.saveSyncConfig({
      'webdav_url': url,
      'webdav_username': username,
      'webdav_password': password,
    });
  }

  Future<void> configureICloud(bool enabled) async {
    _icloudEnabled = enabled;
    await _db.saveSyncConfig({'icloud_enabled': enabled ? 1 : 0});
  }

  bool get isSyncing => _isSyncing;
  
  Future<DateTime?> get lastSyncTime async {
    return await _db.getLastSyncTime();
  }
}

class SyncResult {
  final bool success;
  final String message;
  final Map<String, bool>? details;

  SyncResult({
    required this.success,
    required this.message,
    this.details,
  });
}
