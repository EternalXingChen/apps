import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/notification_service.dart';

class TaskEditScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskEditScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority _priority = TaskPriority.medium;
  TaskRepeatRule _repeatRule = TaskRepeatRule.none;
  int? _reminderMinutes;
  String _notificationSound = '默认铃声';

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate;
    _dueTime = task?.dueTime;
    _priority = task?.priority ?? TaskPriority.medium;
    _repeatRule = task?.repeatRule ?? TaskRepeatRule.none;
    _reminderMinutes = task?.reminderMinutes;
    _notificationSound = task?.notificationSound ?? '默认铃声';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑任务' : '新建任务'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '任务标题',
                hintText: '输入任务标题',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入任务标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '任务描述',
                hintText: '输入任务描述（可选）',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('截止日期'),
              subtitle: Text(_dueDate != null
                  ? '${_dueDate!.year}/${_dueDate!.month}/${_dueDate!.day}'
                  : '未设置'),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _dueDate = null),
                    )
                  : null,
              onTap: _selectDueDate,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('截止时间'),
              subtitle: Text(_dueTime != null
                  ? '${_dueTime!.hour.toString().padLeft(2, '0')}:${_dueTime!.minute.toString().padLeft(2, '0')}'
                  : '未设置'),
              trailing: _dueTime != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _dueTime = null),
                    )
                  : null,
              onTap: _selectDueTime,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('任务提醒'),
              subtitle: Text(_reminderMinutes != null
                  ? '提前 ${_getReminderText(_reminderMinutes!)}'
                  : '未设置'),
              trailing: _reminderMinutes != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _reminderMinutes = null),
                    )
                  : null,
              onTap: _selectReminder,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('提醒铃声'),
              subtitle: Text(_notificationSound),
              onTap: _selectReminderSound,
            ),
            const SizedBox(height: 16),
            const Text('优先级', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              selected: {_priority},
              onSelectionChanged: (selected) {
                setState(() => _priority = selected.first);
              },
              segments: TaskPriority.values.map((priority) {
                return ButtonSegment(
                  value: priority,
                  label: Text(priority.label),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('重复', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<TaskRepeatRule>(
              selected: {_repeatRule},
              onSelectionChanged: (selected) {
                setState(() => _repeatRule = selected.first);
              },
              segments: TaskRepeatRule.values.map((rule) {
                return ButtonSegment(
                  value: rule,
                  label: Text(rule.label),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    // 验证必填字段
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入任务标题')),
      );
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择截止日期')),
      );
      return;
    }

    final task = TaskModel(
      id: widget.task?.id,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      dueDate: _dueDate,
      dueTime: _dueTime,
      priority: _priority,
      repeatRule: _repeatRule,
      reminderMinutes: _reminderMinutes,
      notificationSound: _notificationSound,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<TaskProvider>();
    if (widget.task != null) {
      await provider.updateTask(task);
    } else {
      await provider.addTask(task);
    }

    final settings = context.read<SettingsProvider>();
    final notificationsEnabled = settings.notificationsEnabled;
    final useSound = notificationsEnabled && task.notificationSound != '静音';

    if (notificationsEnabled && useSound) {
      try {
        await NotificationService().showImmediateNotification(
          title: '任务已保存',
          body: '任务“${task.title}”已创建',
          useDefaultSound: useSound,
        );
      } catch (e) {
        print('Failed to show immediate notification: $e');
      }
    }

    // Schedule notification if notifications are enabled and due date/time are set
    if (notificationsEnabled && _dueDate != null && _dueTime != null && _reminderMinutes != null) {
      try {
        await NotificationService().scheduleTaskReminder(task);
      } catch (e) {
        // Ignore notification scheduling errors to prevent save failure
        print('Failed to schedule notification: $e');
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _getReminderText(int minutes) {
    if (minutes < 60) return '$minutes 分钟';
    if (minutes == 60) return '1 小时';
    if (minutes < 1440) return '${minutes ~/ 60} 小时';
    return '${minutes ~/ 1440} 天';
  }

  Future<void> _selectDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _dueTime = picked);
    }
  }

  Future<void> _selectReminder() async {
    final options = [15, 30, 60, 120, 1440, 2880];
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择提醒时间'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((minutes) => ListTile(
            title: Text('提前 ${_getReminderText(minutes)}'),
            leading: Radio<int>(
              value: minutes,
              groupValue: _reminderMinutes,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            onTap: () => Navigator.pop(context, minutes),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
    if (selected != null) {
      setState(() => _reminderMinutes = selected);
    }
  }

  Future<void> _selectReminderSound() async {
    final options = ['默认铃声', '静音'];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择提醒铃声'),
        children: options.map((sound) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, sound),
          child: Text(sound),
        )).toList(),
      ),
    );
    if (selected != null) {
      setState(() {
        _notificationSound = selected;
      });
    }
  }
}
