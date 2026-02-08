import '../../domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks(String projectId);
  Future<void> initialSync(String projectId);

}
