import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

enum TaskRepeatRule {
  none,
  daily,
  weekly,
  monthly,
}

extension TaskPriorityExtension on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return '低';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.high:
        return '高';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

extension TaskRepeatRuleExtension on TaskRepeatRule {
  String get label {
    switch (this) {
      case TaskRepeatRule.none:
        return '不重复';
      case TaskRepeatRule.daily:
        return '每天';
      case TaskRepeatRule.weekly:
        return '每周';
      case TaskRepeatRule.monthly:
        return '每月';
    }
  }
}

class TaskModel {
  final String? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final TaskPriority priority;
  final TaskRepeatRule repeatRule;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TaskModel({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.dueTime,
    this.priority = TaskPriority.medium,
    this.repeatRule = TaskRepeatRule.none,
    this.isCompleted = false,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'dueTime': dueTime != null
          ? '${dueTime!.hour.toString().padLeft(2, '0')}:${dueTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'priority': priority.index,
      'repeatRule': repeatRule.name,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parsedTime;
    if (json['dueTime'] != null) {
      final parts = json['dueTime'].toString().split(':');
      parsedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      dueTime: parsedTime,
      priority: TaskPriority.values[json['priority'] ?? 1],
      repeatRule: TaskRepeatRule.values.byName(json['repeatRule'] ?? 'none'),
      isCompleted: json['isCompleted'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TaskPriority? priority,
    TaskRepeatRule? repeatRule,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      repeatRule: repeatRule ?? this.repeatRule,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
