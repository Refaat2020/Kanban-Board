import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

import '../../../../core/services/isar_service.dart';
import '../../domain/entities/task.dart';
import '../models/task_local_model.dart';
import 'task_local_data_source.dart';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Isar _isar = IsarService.isar;

  @override
  Future<List<Task>> getTasks(String projectId) async {
    final tasks = await _isar.taskLocalModels
        .filter()
        .projectIdEqualTo(projectId)
        .findAll();

    return tasks.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> upsertTask(TaskLocalModel task) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.taskLocalModels
          .filter()
          .labelsElementContains(task.labels?.first ?? '')
          .findFirst();
      Logger().e(existing);
      if (existing != null) {
        existing
          ..taskId = task.taskId
          ..content = task.content
          ..description = task.description
          ..projectId = task.projectId
          ..sectionId = task.sectionId
          ..order = task.order
          ..priority = task.priority
          ..isCompleted = task.isCompleted
          ..dueString = task.dueString
          ..labels = task.labels
          ..isSynced = task.isSynced;

        await _isar.taskLocalModels.put(existing);
      } else {
        await _isar.taskLocalModels.put(task);
      }
    });
  }

  @override
  Future<void> saveTasks(List<TaskLocalModel> tasks) async {
    if (tasks.isEmpty) return;

    final taskIds = tasks.map((e) => e.taskId).toList();

    await _isar.writeTxn(() async {
      final existing = await _isar.taskLocalModels
          .filter()
          .anyOf(taskIds, (q, id) => q.taskIdEqualTo(id))
          .findAll();

      // 2️⃣ map: taskId -> isarId
      final existingMap = {for (final e in existing) e.taskId: e.isarId};

      for (final task in tasks) {
        final isarId = existingMap[task.taskId];
        if (isarId != null) {
          task.isarId = isarId;
        }
      }

      // 4️⃣ batch upsert
      await _isar.taskLocalModels.putAll(tasks);
    });
  }

  @override
  Future<List<TaskLocalModel>> getUnsyncedTasks() {
    return _isar.taskLocalModels.filter().isSyncedEqualTo(false).findAll();
  }
}
