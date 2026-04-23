import 'package:flutter/material.dart';
import '../../data/repositories/sync_repository.dart';
import '../../data/services/notification_service.dart';
import '../theme/app_theme.dart';

/// 应用初始化器
/// 负责应用启动时的所有初始化工作
class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  factory AppInitializer() => _instance;
  AppInitializer._internal();

  bool _initialized = false;
  
  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 初始化应用
  /// 
  /// [context] - 构建上下文
  /// 返回初始化是否成功
  Future<bool> initialize(BuildContext context) async {
    if (_initialized) return true;

    try {
      // 初始化通知服务
      await _initializeNotifications();
      
      // 初始化同步服务
      await _initializeSync();
      
      // 预加载主题
      _preloadTheme(context);
      
      _initialized = true;
      return true;
    } catch (e) {
      debugPrint('App initialization failed: $e');
      return false;
    }
  }

  /// 初始化通知服务
  Future<void> _initializeNotifications() async {
    final notificationService = NotificationService();
    await notificationService.initialize();
  }

  /// 初始化同步服务
  Future<void> _initializeSync() async {
    final syncRepository = SyncRepository();
    await syncRepository.initialize();
  }

  /// 预加载主题
  void _preloadTheme(BuildContext context) {
    // 预加载常用颜色，避免运行时计算
    final theme = Theme.of(context);
    final appColors = AppTheme.colors;
    
    // 触发颜色计算
    appColors.toString();
    theme.primaryColor;
  }

  /// 延迟初始化（后台）
  /// 
  /// 用于在应用启动后执行非关键初始化
  Future<void> delayedInitialization() async {
    if (!_initialized) return;

    // 延迟执行后台任务
    await Future.delayed(const Duration(seconds: 2));
    
    // 清理过期数据
    await _cleanupExpiredData();
    
    // 预加载统计数据
    await _preloadStatistics();
  }

  /// 清理过期数据
  Future<void> _cleanupExpiredData() async {
    // 清理已完成的过期任务
    // 清理旧的日记条目（保留最近100条）
    // 清理旧的财务记录（保留最近1年）
  }

  /// 预加载统计数据
  Future<void> _preloadStatistics() async {
    // 预计算常用统计数据
    // 缓存月度财务汇总
    // 缓存任务完成率
  }
}
