import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/constants/app_colors.dart';
import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/fetch_tasks.dart';
import '../../domain/usecases/initial_sync_tasks.dart';

part 'kanban_state.dart';

class KanbanCubit extends Cubit<KanbanState> {
  KanbanCubit(this._taskUsecase,this._syncTasks) : super(KanbanInitial());

  final FetchTasks _taskUsecase;
  final InitialSyncTasks _syncTasks;

  List<KanbanColumnData> columnDataList = [];

  Future<void> fetchTasks(String projectId) async {
    emit(KanbanLoading());
    var result = _taskUsecase.call(projectId);
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
  Future<void> syncTasks(String projectId) async {
    emit(KanbanLoading());
    var result = _syncTasks.call(projectId);
    await result.execute(
      onFailed: (failed) => emit(KanbanError(errorMessage: failed.message)),
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
      columnName: AppStrings.todo,
      tasks: todoList,
      columnColor: AppColors.geryColor,
    );
    final inProgressColumn = KanbanColumnData(
      columnId: TaskStatus.inProgress.index + 1,
      columnName: AppStrings.inProgress,
      tasks: inProgressList,
      columnColor: AppColors.purple2,
    );
    final doneColumn = KanbanColumnData(
      columnId: TaskStatus.done.index + 1,
      columnName: AppStrings.done,
      tasks: doneList,
      columnColor: AppColors.green,
    );

    columnDataList.addAll([todoColumn, inProgressColumn, doneColumn]);
    emit(KanbanFilteredTasks(filteredTasks: columnDataList));
  }
}
