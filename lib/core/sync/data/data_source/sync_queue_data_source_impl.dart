import 'package:isar_community/isar.dart';
import 'package:kanban_board/core/services/isar_service.dart';
import 'package:logger/logger.dart';

import '../models/sync_queue_item.dart';
import 'sync_queue_data_source.dart';

class SyncQueueDataSourceImpl implements SyncQueueDataSource {
  final Isar _isar = IsarService.isar;

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.syncQueueItems
          .filter()
          .entityIdEqualTo(item.entityId)
          .entityTypeEqualTo(item.entityType)
          .findFirst();
      if (existing != null) {
        Logger().f(existing.payload);
        existing
          ..payload = item.payload
          ..action = item.action
          ..nextRetryAt = DateTime.now();

        await _isar.syncQueueItems.put(existing);
      } else {
        Logger().f(item.payload);
        await _isar.syncQueueItems.put(item);
      }
    });
  }

  @override
  Future<List<SyncQueueItem>> getReadyItems(DateTime now) {
    return _isar.syncQueueItems.filter().nextRetryAtLessThan(now).findAll();
  }

  @override
  Future<void> update(SyncQueueItem item) async {
    await _isar.writeTxn(() async {
      await _isar.syncQueueItems.put(item);
    });
  }

  @override
  Future<void> remove(SyncQueueItem item) async {
    await _isar.writeTxn(() async {
      await _isar.syncQueueItems.delete(item.isarId);
    });
  }
}
