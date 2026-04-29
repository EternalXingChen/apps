import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'backup_screen.dart';
import 'sync_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionHeader(context, l10n.theme),

          // 深色模式
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: Text(l10n.theme),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (value) {
              settings.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),

          const Divider(),

          // 日历设置
          _buildSectionHeader(context, '日历设置'),

          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('日历语言'),
                subtitle: Text(settings.calendarLocale == 'zh_CN' ? '中文' : 'English'),
                trailing: Switch(
                  value: settings.calendarLocale == 'zh_CN',
                  onChanged: (value) {
                    settings.setCalendarLocale(value ? 'zh_CN' : 'en_US');
                  },
                ),
              );
            },
          ),

          const Divider(),

          // 语言设置
          _buildSectionHeader(context, l10n.language),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(settings.appLocale == 'zh_CN' ? '中文' : 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context),
          ),

          const Divider(),

          // 通知设置
          _buildSectionHeader(context, l10n.notification),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: Text(l10n.notification),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              settings.setNotificationsEnabled(value);
            },
          ),

          const Divider(),

          // 数据管理
          _buildSectionHeader(context, '数据管理'),

          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.backup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BackupScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(l10n.sync),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SyncScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              '清除所有数据',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _showClearDataDialog(context, l10n),
          ),

          const Divider(),

          // 关于
          _buildSectionHeader(context, l10n.about),

          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.version),
            subtitle: const Text('1.0.0'),
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('隐私政策'),
            onTap: () {
              _showPrivacyPolicy(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('中文'),
              trailing: settings.appLocale == 'zh_CN'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                settings.setAppLocale('zh_CN');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: settings.appLocale == 'en_US'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                settings.setAppLocale('en_US');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            '此应用尊重您的隐私，所有数据仅保存在本地存储，除非您主动选择备份或同步。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有数据'),
        content: const Text(
          '这将永久删除您的所有数据。此操作无法撤销。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? '取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('所有数据已清除'),
                ),
              );
            },
            child: Text(
              l10n?.confirm ?? '确认',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
