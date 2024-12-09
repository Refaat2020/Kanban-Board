import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';

class TaskManagementService {
  final TaskManagementRepository _taskManagementRepository;

  TaskManagementService(this._taskManagementRepository);

  Future<Task> createTask(Task task) async {
    try {
      return await _taskManagementRepository.createTask(task);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  Future<Task> updateTask(Task task, String id) async {
    try {
      return await _taskManagementRepository.updateTask(task, id);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
