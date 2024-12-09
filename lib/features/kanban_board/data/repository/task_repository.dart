import 'package:kanban_board/features/kanban_board/data/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(String projectId);
}
