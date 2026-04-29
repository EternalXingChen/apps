import 'package:flutter/material.dart';
import '../../core/sync_service.dart';
import '../../models/sync_config.dart';
import '../../services/database_service.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final DatabaseService _db = DatabaseService();
  String _provider = 'local';
  bool _autoSync = false;
  String _syncInterval = 'daily';
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _db.getSyncConfig();
    if (config != null) {
      setState(() {
        _provider = config.provider;
        _autoSync = config.autoSync;
        _syncInterval = config.syncInterval;
        _serverUrlController.text = config.serverUrl ?? '';
        _usernameController.text = config.username ?? '';
        _passwordController.text = config.password ?? '';
      });
    }
  }

  Future<void> _saveConfig() async {
    final config = SyncConfig(
      autoSync: _autoSync,
      syncInterval: _syncInterval,
      provider: _provider,
      serverUrl: _serverUrlController.text.trim().isEmpty
          ? null
          : _serverUrlController.text.trim(),
      username: _usernameController.text.trim().isEmpty
          ? null
          : _usernameController.text.trim(),
      password: _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
    );
    await _db.saveSyncConfig(config);
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _runSync() async {
    setState(() => _isSyncing = true);
    
    // 保存配置
    await _saveConfig();
    
    final config = SyncConfig(
      autoSync: _autoSync,
      syncInterval: _syncInterval,
      provider: _provider,
      serverUrl: _serverUrlController.text.trim().isEmpty
          ? null
          : _serverUrlController.text.trim(),
      username: _usernameController.text.trim().isEmpty
          ? null
          : _usernameController.text.trim(),
      password: _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
    );

    final success = await SyncService().performSync(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? '同步成功' : '同步失败')), 
      );
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('同步设置'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('同步方式', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _provider,
              items: const [
                DropdownMenuItem(value: 'local', child: Text('本地')), 
                DropdownMenuItem(value: 'WebDAV', child: Text('WebDAV')),
                DropdownMenuItem(value: 'iCloud', child: Text('iCloud')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _provider = value);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('自动同步'),
              value: _autoSync,
              onChanged: (value) => setState(() => _autoSync = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _syncInterval,
              items: const [
                DropdownMenuItem(value: '15min', child: Text('每 15 分钟')), 
                DropdownMenuItem(value: '1hour', child: Text('每 1 小时')), 
                DropdownMenuItem(value: 'daily', child: Text('每天')), 
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _syncInterval = value);
                }
              },
              decoration: const InputDecoration(labelText: '同步频率'),
            ),
            if (_provider == 'WebDAV' || _provider == 'iCloud') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _serverUrlController,
                decoration: const InputDecoration(
                  labelText: '服务器地址',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '密码',
                ),
                obscureText: true,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSyncing ? null : _runSync,
              child: Text(_isSyncing ? '同步中...' : '立即同步'),
            ),
          ],
        ),
      ),
    );
  }
}
