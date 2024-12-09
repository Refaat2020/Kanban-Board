part of 'kanban_cubit.dart';

abstract class KanbanState {}

class KanbanInitial extends KanbanState {}

class KanbanLoading extends KanbanState {}

class KanbanTasksLoaded extends KanbanState {
  final List<Task> tasks;

  KanbanTasksLoaded({required this.tasks});
}

class KanbanEmptyTasks extends KanbanState {}

class KanbanFilteredTasks extends KanbanState {
  final List<KanbanColumnData> filteredTasks;

  KanbanFilteredTasks({required this.filteredTasks});
}

class KanbanError extends KanbanState {
  final String? errorMessage;

  KanbanError({this.errorMessage});
}
