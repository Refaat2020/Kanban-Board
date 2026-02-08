import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';

import '../entities/task.dart';

class FetchTasks {
  final TaskRepository repository;

  FetchTasks(this.repository);

  Future<List<Task>> call(String projectId) {
    return repository.fetchTasks(projectId);
  }
}
