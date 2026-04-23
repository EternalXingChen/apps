import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sync_config.dart';
import '../../domain/services/sync_service.dart';
import '../../infrastructure/services/cloud_sync_service.dart';
import '../../infrastructure/services/webdav_sync_service.dart';

// Sync service provider
final syncServiceProvider = Provider Provider<SyncService>((ref) {
  return CloudSyncService();
});

// Sync configuration provider
final syncConfigProvider = StateNotifierProviderProvider<SyncConfigNotifier, SyncConfig?>((ref) {
  return SyncConfigNotifier();
});

// Sync status provider
final syncStatusProvider = StateNotifierProviderProvider<SyncStatusNotifier, SyncStatus>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return SyncStatusNotifier(syncService);
});

// Last sync time provider
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

// Auto sync enabled provider
final autoSyncEnabledProvider = StateProvider<bool>((ref) => true);

class SyncConfigNotifier extends StateNotifierNotifier<SyncConfig?> {
  SyncConfigNotifier() : super(null);

  void loadConfig(SyncConfig config) {
    state = config;
  }

  void updateConfig(SyncConfig config) {
    state = config;
  }

  void clearConfig() {
    state = null;
  }
}

class SyncStatusNotifier extends StateNotifierNotifier<SyncStatus> {
  final SyncService _syncService;

  SyncStatusNotifier(this._syncService) : super(SyncStatus.idle);

  Future<void> sync() async {
    if (state == SyncStatus.syncing) return;

    state = SyncStatus.syncing;

    try {
      await _syncService.syncAll();
      state = SyncStatus.success;
    } catch (e) {
      debugPrint('Sync error: $e');
      state = SyncStatus.error;
    }
  }

  Future<void> syncFinances() async {
    if (state == SyncStatus.syncing) return;

    state = SyncStatus.syncing;

    try {
      await _syncService.syncFinances();
      state = SyncStatus.success;
    } catch (e) {
      debugPrint('Finance sync error: $e');
      state = SyncStatus.error;
    }
  }

  Future<void> syncJournals() async {
    if (state == SyncStatus.syncing) return;

    state = SyncStatus.syncing;

    try {
      await _syncService.syncJournals();
      state = SyncStatus.success;
    } catch (e) {
      debugPrint('Journal sync error: $e');
      state = SyncStatus.error;
    }
  }

  Future<void> syncTasks() async {
    if (state == SyncStatus.syncing) return;

    state = SyncStatus.syncing;

    try {
      await _syncService.syncTasks();
      state = SyncStatus.success;
    } catch (e) {
      debugPrint('Task sync error: $e');
      state = SyncStatus.error;
    }
  }

  void reset() {
    state = SyncStatus.idle;
  }
}

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}
