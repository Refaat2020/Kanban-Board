import '../../domain/entities/task.dart';
import '../models/task_local_model.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getTasks(String projectId);
  Future<void> upsertTask(TaskLocalModel task);
  Future<void> saveTasks(List<TaskLocalModel> tasks);
  Future<List<TaskLocalModel>> getUnsyncedTasks();
}