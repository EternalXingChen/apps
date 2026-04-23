import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import 'backup_restore_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = Provider.of.of<SettingsProvider>(context);
    final themeProvider = Provider.of.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settings ?? 'Settings'),
      ),
      body: ListView(
        children: [
          // 外观设置
          _buildSectionHeader(context, l10n?.appearance ?? 'Appearance'),
          
          // 深色模式
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: Text(l10n?.darkMode ?? 'Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.setDarkMode(value),
          ),
          
          // 主题色
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(l10n?.themeColor ?? 'Theme Color'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: themeProvider.themeColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () => _showColorPicker(context, themeProvider),
          ),
          
          const Divider(),
          
          // 语言设置
          _buildSectionHeader(context, l10n?.language ?? 'Language'),
          
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n?.language ?? 'Language'),
            subtitle: Text(_getLanguageName(settingsProvider.locale.languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, settingsProvider),
          ),
          
          const Divider(),
          
          // 通知设置
          _buildSectionHeader(context, l10n?.notifications ?? 'Notifications'),
          
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: Text(l10n?.enableNotifications ?? 'Enable Notifications'),
            value: settingsProvider.notificationsEnabled,
            onChanged: (value) => settingsProvider.setNotificationsEnabled(value),
          ),
          
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: Text(l10n?.soundEffects ?? 'Sound Effects'),
            value: settingsProvider.soundEnabled,
            onChanged: (value) => settingsProvider.setSoundEnabled(value),
          ),
          
          const Divider(),
          
          // 数据管理
          _buildSectionHeader(context, l10n?.dataManagement ?? 'Data Management'),
          
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n?.backupRestore ?? 'Backup & Restore'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupRestoreScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: Text(
              l10n?.clearAllData ?? 'Clear All Data',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _showClearDataDialog(context, l10n),
          ),
          
          const Divider(),
          
          // 关于
          _buildSectionHeader(context, l10n?.about ?? 'About'),
          
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n?.version ?? 'Version'),
            subtitle: const Text('1.0.0'),
          ),
          
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(l10n?.privacyPolicy ?? 'Privacy Policy'),
            onTap: () {
              // TODO: 打开隐私政策
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

  String _getLanguageName(String code) {
    switch (code) {
      case 'zh':
        return '中文';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }

  void _showColorPicker(BuildContext context, ThemeProvider provider) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.red,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择主题色'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                provider.setThemeColor(color);
                Navigator.pop(context);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.themeColor == color
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('中文'),
              trailing: provider.locale.languageCode == 'zh'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                provider.setLocale(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: provider.locale.languageCode == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                provider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.clearAllData ?? 'Clear All Data'),
        content: Text(
          l10n?.clearDataConfirm ?? 
          'This will permanently delete all your data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 清除所有数据
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n?.dataCleared ?? 'All data has been cleared'),
                ),
              );
            },
            child: Text(
              l10n?.confirm ?? 'Confirm',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
