import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/tasks/task_list_item.dart';
import '../../widgets/common/empty_state.dart';
import 'task_edit_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTasks() async {
    await context.read<TaskProvider>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待办'),
            Tab(text: '已完成'),
            Tab(text: '全部'),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(provider.pendingTasks),
              _buildTaskList(provider.completedTasks),
              _buildTaskList(provider.tasks),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildTaskList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const EmptyState(
        icon: Icons.check_circle_outline,
        title: '暂无任务',
        subtitle: '点击右下角按钮创建新任务',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(
          task: task,
          onTap: () => _editTask(task),
          onToggleComplete: () => _toggleTaskComplete(task),
          onDelete: () => _deleteTask(task),
        );
      },
    );
  }
  
  void _createNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskEditScreen(),
      ),
    ).then((_) async {
      await _loadTasks();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _editTask(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditScreen(task: task),
      ),
    ).then((_) async {
      await _loadTasks();
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  Future<void> _toggleTaskComplete(TaskModel task) async {
    await context.read<TaskProvider>().toggleTaskComplete(task.id!);
  }
  
  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除任务"${task.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirmed == true && task.id != null) {
      await context.read<TaskProvider>().deleteTask(task.id!);
    }
  }
}
