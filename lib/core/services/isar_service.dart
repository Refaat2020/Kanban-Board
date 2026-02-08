import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/kanban_board/data/models/task_local_model.dart';
import '../sync/data/models/sync_queue_item.dart';

class IsarService {
  static late final Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([
      TaskLocalModelSchema,
      SyncQueueItemSchema,
    ], directory: dir.path);
  }
}
