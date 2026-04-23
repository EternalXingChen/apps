import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
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
      final data = jsonDecode(payload);
      // Navigate to relevant screen based on payload
    }
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.dueTime == null) return;

    final scheduledDate = tz.TZDateTime.from(task.dueTime!, tz.local);
    
    // Schedule 15 minutes before
    final reminder15Min = scheduledDate.subtract(const Duration(minutes: 15));
    if (reminder15Min.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: task.id.hashCode + 1,
        title: '即将到期: ${task.title}',
        body: '任务将在15分钟后到期',
        scheduledDate: reminder15Min,
        payload: jsonEncode({'taskId': task.id, 'type': 'reminder'}),
      );
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
      importance: Importance.normal,
      priority: Priority.normal,
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
