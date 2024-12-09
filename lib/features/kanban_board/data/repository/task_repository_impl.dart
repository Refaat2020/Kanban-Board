import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource _taskDataSource;

  TaskRepositoryImpl(this._taskDataSource);

  @override
  Future<List<Task>> fetchTasks(String projectId) async {
    try {
      final response = await _taskDataSource.fetchTasks(projectId);
      List<Task> tasks =
          List<Task>.from((response).map((x) => Task.fromJson(x)));
      return tasks;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
