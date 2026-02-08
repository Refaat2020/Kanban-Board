
import 'package:isar_community/isar.dart';

part 'sync_queue_item.g.dart';

@collection
class SyncQueueItem {
  Id isarId = Isar.autoIncrement;

  /// entity id (taskId, commentId, etc.)
   String ?entityId;

  /// task / comment / project
  late String entityType;

  /// create | update | delete
  late String action;

  /// serialized payload (json string)
  late String payload;

  /// retry handling
  late int retryCount;
  late DateTime nextRetryAt;
}