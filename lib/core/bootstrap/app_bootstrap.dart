import 'dart:async';

import '../network/network_info.dart';
import '../services/isar_service.dart';
import '../sync/data/models/sync_queue_item.dart';
import '../sync/engine/background_sync_engine.dart';

class AppBootstrap {
  final BackgroundSyncEngine _syncEngine;
  final NetworkInfo _networkInfo;

  StreamSubscription? _netSub;
  StreamSubscription? _queueSub;
  Timer? _debounce;
  AppBootstrap(this._syncEngine, this._networkInfo);

  void start() {
    // 1️⃣ عند تشغيل التطبيق
    _syncEngine.run();

    // 2️⃣ عند رجوع النت
    _netSub = _networkInfo.onStatusChange.listen((isConnected) {
      if (isConnected) {
        _syncEngine.run();
      }
    });

    // 3️⃣ عند إضافة عناصر في الـ queue
    _queueSub = IsarService.isar.syncQueueItems.watchLazy().listen((_) {
      _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 300),
        () => _syncEngine.run(),
      );
    });
  }

  void dispose() {
    _netSub?.cancel();
    _queueSub?.cancel();
    _debounce?.cancel();
  }
}
