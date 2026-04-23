part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final DateTime? date;

  const LoadTasks({this.date});

  @override
  List<Object?> get props => [date];
}

class AddTask extends TaskEvent {
  final TaskEntity task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTaskCompletion extends TaskEvent {
  final String id;

  const ToggleTaskCompletion(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadTasksByDate extends TaskEvent {
  final DateTime date;

  const LoadTasksByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadTasksByCategory extends TaskEvent {
  final TaskCategory category;

  const LoadTasksByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchTasks extends TaskEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadOverdueTasks extends TaskEvent {
  const LoadOverdueTasks();
}

class LoadTodayTasks extends TaskEvent {
  const LoadTodayTasks();
}

class LoadUpcomingTasks extends TaskEvent {
  const LoadUpcomingTasks();
}
