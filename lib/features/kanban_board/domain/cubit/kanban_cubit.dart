import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/constants/app_colors.dart';
import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/domain/service/task_service.dart';

part 'kanban_state.dart';

class KanbanCubit extends Cubit<KanbanState> {
  KanbanCubit(this._taskService) : super(KanbanInitial());

  final TaskService _taskService;

  List<KanbanColumnData> columnDataList = [];

  Future<void> fetchTasks(String projectId) async {
    emit(KanbanLoading());
    var result = _taskService.fetchTasks(projectId);
    await result.execute(
      onFailed: (failed) => emit(KanbanError(errorMessage: failed.message)),
      onSuccess: (tasks) async {
        if (tasks.isEmpty) {
          emit(KanbanEmptyTasks());
        } else {
          emit(KanbanTasksLoaded(tasks: tasks));
        }
      },
    );
  }

  void filterTasks(List<Task> tasks) {
    columnDataList.clear();
    final todoList = tasks
        .where(
          (element) => element.priority == TaskStatus.todo.index + 1,
        )
        .toList();
    final inProgressList = tasks
        .where(
          (element) => element.priority == TaskStatus.inProgress.index + 1,
        )
        .toList();
    final doneList = tasks
        .where(
          (element) => element.priority == TaskStatus.done.index + 1,
        )
        .toList();

    final todoColumn = KanbanColumnData(
        columnId: TaskStatus.todo.index + 1,
        columnName: 'To Do',
        tasks: todoList,
        columnColor: AppColors.geryColor);
    final inProgressColumn = KanbanColumnData(
        columnId: TaskStatus.inProgress.index + 1,
        columnName: 'In Progress',
        tasks: inProgressList,
        columnColor: AppColors.purple2);
    final doneColumn = KanbanColumnData(
        columnId: TaskStatus.done.index + 1,
        columnName: 'Done',
        tasks: doneList,
        columnColor: AppColors.green);

    columnDataList.addAll([todoColumn, inProgressColumn, doneColumn]);
    emit(KanbanFilteredTasks(filteredTasks: columnDataList));
  }
}
