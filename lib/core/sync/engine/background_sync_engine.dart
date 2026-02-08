import 'dart:async';
import 'dart:convert';

import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';

import '../../../../features/kanban_board/data/data_source/task_local_data_source.dart';
import '../../../../features/kanban_board/data/models/task_local_model.dart';
import '../../../../features/kanban_board/data/models/task_model.dart';
import '../../../features/task_management/data/data_source/task_management_data_source.dart';
import '../../network/network_info.dart';
import '../data/data_source/sync_queue_data_source.dart';
import '../data/models/sync_queue_item.dart';

class BackgroundSyncEngine {
  final SyncQueueDataSource _queue;
  final TaskManagementDataSource _remote;
  final TaskLocalDataSource _local;
  final NetworkInfo _networkInfo;

  bool _isRunning = false;

  BackgroundSyncEngine(
    this._queue,
    this._remote,
    this._local,
    this._networkInfo,
  );

  Future<void> run() async {
    if (_isRunning) return;
    _isRunning = true;

    try {
      if (!await _networkInfo.isConnected) return;

      final now = DateTime.now();
      final items = await _queue.getReadyItems(now);

      for (final item in items) {
        await _processItem(item);
      }
    } finally {
      _isRunning = false;
    }
  }

  Future<void> _processItem(SyncQueueItem item) async {
    try {
      if (item.entityType == 'task') {
        await _processTask(item);
      }
      await _queue.remove(item);
    } catch (_) {
      await _scheduleRetry(item);
    }
  }

  Future<void> _processTask(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload);
    switch (item.action) {
      case 'create':
        final response = await _remote.createTask(payload);

        Task syncedTask = TaskModel.fromJson(response).toEntity();
        syncedTask = syncedTask.copyWith(localId: payload['assigner_id']);
        await _local.upsertTask(
          TaskLocalModel.fromEntity(syncedTask, isSynced: true),
        );
        break;

      case 'update':
        final response = await _remote.updateTask(payload, item.entityId!);

        final syncedTask = TaskModel.fromJson(response).toEntity();

        await _local.upsertTask(
          TaskLocalModel.fromEntity(syncedTask, isSynced: true),
        );
        break;

      default:
        throw Exception('Unsupported action ${item.action}');
    }
  }

  Future<void> _scheduleRetry(SyncQueueItem item) async {
    final delay = _calculateBackoff(item.retryCount);

    item
      ..retryCount += 1
      ..nextRetryAt = DateTime.now().add(Duration(seconds: delay));

    await _queue.update(item);
  }

  int _calculateBackoff(int retryCount) {
    // exponential backoff: 2, 4, 8, 16… max 5 min
    return (2 << retryCount).clamp(2, 300);
  }
}
