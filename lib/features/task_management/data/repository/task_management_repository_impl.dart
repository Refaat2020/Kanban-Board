import 'dart:convert';

import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';

import '../../../../core/sync/data/data_source/sync_queue_data_source.dart';
import '../../../../core/sync/data/models/sync_queue_item.dart';
import '../../../kanban_board/data/data_source/task_local_data_source.dart';
import '../../../kanban_board/data/models/task_local_model.dart';
import '../../../kanban_board/domain/entities/task.dart';

class TaskManagementRepositoryImpl implements TaskManagementRepository {
  final TaskLocalDataSource _local;
  final SyncQueueDataSource _queue;
  TaskManagementRepositoryImpl(this._local, this._queue);

  @override
  Future<Task> createTask(Task task) async {
    try {
      final localTask = TaskLocalModel.fromEntity(task, isSynced: false);

      await _local.upsertTask(localTask);

      await _queue.enqueue(
        SyncQueueItem()
          ..entityId = task.id
          ..entityType = 'task'
          ..action = 'create'
          ..payload = jsonEncode(TaskModel.fromEntity(task).toJson())
          ..retryCount = 0
          ..nextRetryAt = DateTime.now(),
      );

      return localTask.toEntity();
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<Task> updateTask(Task task, String taskId) async {
    try {
      // 1️⃣ local update (source of truth)
      final localTask = TaskLocalModel.fromEntity(task, isSynced: false);

      await _local.upsertTask(localTask);
      // 2️⃣ enqueue sync item
      await _queue.enqueue(
        SyncQueueItem()
          ..entityId = taskId
          ..entityType = 'task'
          ..action = 'update'
          ..payload = jsonEncode(TaskModel.fromEntity(task).toJson())
          ..retryCount = 0
          ..nextRetryAt = DateTime.now(),
      );

      return localTask.toEntity();
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
