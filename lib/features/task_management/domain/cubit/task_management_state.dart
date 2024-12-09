part of 'task_management_cubit.dart';

@immutable
abstract class TaskManagementState {}

class TaskManagementInitial extends TaskManagementState {}

class TaskManagementLoading extends TaskManagementState {}

class TaskManagementDone extends TaskManagementState {}

class TaskManagementUpdatedDone extends TaskManagementState {
  final Task task;

  TaskManagementUpdatedDone(this.task);
}

class TaskSelectedStatus extends TaskManagementState {}

class TaskManagementError extends TaskManagementState {
  final String? errorMessage;

  TaskManagementError({this.errorMessage});
}
