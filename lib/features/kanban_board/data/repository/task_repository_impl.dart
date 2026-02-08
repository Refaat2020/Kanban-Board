import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';

import '../../domain/entities/task.dart';
import '../data_source/task_local_data_source.dart';
import '../data_source/tasks_data_source.dart';
import '../models/task_local_model.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  final TaskDataSource _remoteDataSource;

  const TaskRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<Task>> fetchTasks(String projectId) async {
    try {
      return await _localDataSource.getTasks(projectId);
    } on FailureModel {
      rethrow;
    } catch (e) {
      print(e.toString());
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<void> initialSync(String projectId) async {
    final remoteTasks = await _remoteDataSource.fetchTasks(projectId);

    final entities = remoteTasks
        .map((json) => TaskModel.fromJson(json).toEntity())
        .toList();

    await _localDataSource.saveTasks(
      entities.map(TaskLocalModel.fromEntity).toList(),
    );
  }
}
