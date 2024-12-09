import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  Future<List<Task>> fetchTasks(String projectId) async {
    try {
      return await _taskRepository.fetchTasks(projectId);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
