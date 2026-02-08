
import '../../../kanban_board/domain/entities/task.dart';

abstract class TaskManagementRepository {
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task, String taskId);
}
