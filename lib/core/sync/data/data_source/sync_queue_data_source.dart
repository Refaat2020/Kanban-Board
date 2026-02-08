import '../models/sync_queue_item.dart';

abstract class SyncQueueDataSource {
  Future<void> enqueue(SyncQueueItem item);

  Future<List<SyncQueueItem>> getReadyItems(DateTime now);

  Future<void> update(SyncQueueItem item);

  Future<void> remove(SyncQueueItem item);
}