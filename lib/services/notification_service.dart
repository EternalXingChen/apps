import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/task_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = jsonDecode(payload);
        final taskId = data['taskId'];

        if (taskId != null) {
          // Navigate to task detail screen
          navigatorKey.currentState?.pushNamed('/tasks/edit', arguments: taskId);
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.dueDate == null || task.dueTime == null) return;

    // Cancel existing notifications for this task
    await cancelTaskNotifications(task.id!);

    final scheduledDate = tz.TZDateTime.from(
      DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
        task.dueTime!.hour,
        task.dueTime!.minute,
      ),
      tz.local,
    );

    // Schedule reminder before due time if reminderMinutes is set
    if (task.reminderMinutes != null && task.reminderMinutes! > 0) {
      final reminderDate = scheduledDate.subtract(
        Duration(minutes: task.reminderMinutes!),
      );
      if (reminderDate.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: task.id.hashCode + 1,
          title: '任务提醒: ${task.title}',
          body: '任务将在 ${_getReminderText(task.reminderMinutes!)} 后到期',
          scheduledDate: reminderDate,
          payload: jsonEncode({'taskId': task.id, 'type': 'reminder'}),
        );
      }
    }

    // Schedule at due time
    if (scheduledDate.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: task.id.hashCode,
        title: '任务到期: ${task.title}',
        body: task.priority == TaskPriority.high
            ? '⚠️ 高优先级任务已到期'
            : '任务已到期',
        scheduledDate: scheduledDate,
        payload: jsonEncode({'taskId': task.id, 'type': 'due'}),
      );
    }
  }

  String _getReminderText(int minutes) {
    if (minutes < 60) return '$minutes 分钟';
    if (minutes == 60) return '1 小时';
    if (minutes < 1440) return '${minutes ~/ 60} 小时';
    return '${minutes ~/ 1440} 天';
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      '任务提醒',
      channelDescription: '任务到期和提醒通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelTaskNotifications(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
    await _notifications.cancel(taskId.hashCode + 1);
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      '一般通知',
      channelDescription: '一般应用通知',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
