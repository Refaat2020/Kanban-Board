import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';

class TaskManagementRepositoryImpl implements TaskManagementRepository {
  final TaskManagementDataSource _taskManagementDataSource;

  TaskManagementRepositoryImpl(this._taskManagementDataSource);

  @override
  Future<Task> createTask(Task task) async {
    try {
      final response =
          await _taskManagementDataSource.createTask(task.toJson());
      return Task.fromJson(response);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<Task> updateTask(Task task, String taskId) async {
    try {
      final response =
          await _taskManagementDataSource.updateTask(task.toJson(), taskId);
      return Task.fromJson(response);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
