import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/domain/service/task_management_service.dart';
import 'package:kanban_board/file_export.dart';

part 'task_management_state.dart';

class TaskManagementCubit extends Cubit<TaskManagementState> {
  TaskManagementCubit(this._taskManagementService)
      : super(TaskManagementInitial());

  final TaskManagementService _taskManagementService;

  TaskStatus selectedStatus = TaskStatus.todo;
  String? taskTitle;
  String? taskContent;
  int? taskDuration;
  bool isCompleted = false;

  Future<void> createTask(Task task) async {
    emit(TaskManagementLoading());
    var result = _taskManagementService.createTask(task);
    await result.execute(
      onFailed: (failed) =>
          emit(TaskManagementError(errorMessage: failed.message)),
      onSuccess: (task) async {
        emit(TaskManagementDone());
      },
    );
  }

  Future<void> updateTask(
    Task task,
  ) async {
    emit(TaskManagementLoading());
    var result = _taskManagementService.updateTask(task, task.id ?? "");
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
