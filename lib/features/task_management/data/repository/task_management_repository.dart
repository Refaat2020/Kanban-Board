import 'package:kanban_board/features/kanban_board/data/models/task.dart';

abstract class TaskManagementRepository {
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task, String taskId);
}
