import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/task_management/domain/usecases/create_task.dart';
import 'package:kanban_board/features/task_management/domain/usecases/update_task.dart';
import 'package:kanban_board/file_export.dart';

import '../../../kanban_board/domain/entities/task.dart';

part 'task_management_state.dart';

class TaskManagementCubit extends Cubit<TaskManagementState> {
  TaskManagementCubit(this._createTask, this._updateTask)
    : super(TaskManagementInitial());

  final CreateTask _createTask;
  final UpdateTask _updateTask;

  TaskStatus selectedStatus = TaskStatus.todo;
  String? taskTitle;
  String? taskContent;
  int? taskDuration;
  bool isCompleted = false;

  Future<void> createTask(Task task) async {
    emit(TaskManagementLoading());
    var result = _createTask.call(task);
    await result.execute(
      onFailed: (failed) =>
          emit(TaskManagementError(errorMessage: failed.message)),
      onSuccess: (task) async {
        emit(TaskManagementDone());
      },
    );
  }

  Future<void> updateTask(Task task) async {
    emit(TaskManagementLoading());
    var result = _updateTask.call(task, task.id ?? "");
    await result.execute(
      onFailed: (failed) =>
          emit(TaskManagementError(errorMessage: failed.message)),
      onSuccess: (task) async {
        emit(TaskManagementUpdatedDone(task));
      },
    );
  }

  void selectTaskStatus(TaskStatus taskStatus) {
    selectedStatus = taskStatus;
    emit(TaskSelectedStatus());
  }
}
