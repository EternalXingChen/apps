import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

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
  TaskPriority _priority = TaskPriority.medium;
  TaskRepeatRule _repeatRule = TaskRepeatRule.none;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate;
    _priority = task?.priority ?? TaskPriority.medium;
    _repeatRule = task?.repeatRule ?? TaskRepeatRule.none;
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

    final task = TaskModel(
      id: widget.task?.id,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      dueDate: _dueDate,
      priority: _priority,
      repeatRule: _repeatRule,
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

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
