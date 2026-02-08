import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/core/network/network_info_impl.dart';
import 'package:kanban_board/core/sync/data/data_source/sync_queue_data_source.dart';
import 'package:kanban_board/core/sync/data/models/sync_queue_item.dart';
import 'package:kanban_board/core/sync/engine/background_sync_engine.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/task_local_data_source.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sync_engine_test.mocks.dart';

@GenerateMocks([
  NetworkInfoImpl,
  SyncQueueDataSource,
  TaskManagementDataSource,
  TaskLocalDataSource,
])
void main() {
  late BackgroundSyncEngine engine;
  late MockSyncQueueDataSource mockQueue;
  late MockTaskManagementDataSource mockRemote;
  late MockTaskLocalDataSource mockLocal;
  late MockNetworkInfoImpl mockNetworkInfoImpl;
  setUp(() {
    mockQueue = MockSyncQueueDataSource();
    mockRemote = MockTaskManagementDataSource();
    mockLocal = MockTaskLocalDataSource();
    mockNetworkInfoImpl = MockNetworkInfoImpl();

    engine = BackgroundSyncEngine(
      mockQueue,
      mockRemote,
      mockLocal,
      mockNetworkInfoImpl,
    );
  });

  group('BackgroundSyncEngine', () {
    test(
      'processes update item successfully and updates local + removes queue item',
      () async {
        // Arrange
        final queueItem = SyncQueueItem()
          ..isarId = 1
          ..entityType = 'task'
          ..entityId = 'local-1'
          ..action = 'update'
          ..payload = '{"content":"updated"}'
          ..retryCount = 0
          ..nextRetryAt = DateTime.now();

        when(mockQueue.getReadyItems(any)).thenAnswer((_) async => [queueItem]);
        when(mockNetworkInfoImpl.isConnected).thenAnswer((_) async => true);

        when(mockRemote.updateTask(any, 'local-1')).thenAnswer(
          (_) async => {
            'id': 'remote-1',
            'content': 'updated',
            'description': 'desc',
            'project_id': '123',
          },
        );

        when(mockLocal.upsertTask(any)).thenAnswer((_) async {});
        when(mockQueue.remove(queueItem)).thenAnswer((_) async {});

        // Act
        await engine.run();

        // Assert
        verify(mockRemote.updateTask(any, 'local-1')).called(1);
        verify(mockLocal.upsertTask(any)).called(1);
        verify(mockQueue.remove(queueItem)).called(1);
      },
    );

    test('increments retryCount when remote update fails', () async {
      // Arrange
      final queueItem = SyncQueueItem()
        ..isarId = 1
        ..entityType = 'task'
        ..entityId = 'local-1'
        ..action = 'update'
        ..payload = '{"content":"updated"}'
        ..retryCount = 0
        ..nextRetryAt = DateTime.now();

      when(mockQueue.getReadyItems(any)).thenAnswer((_) async => [queueItem]);
      when(mockNetworkInfoImpl.isConnected).thenAnswer((_) async => true);

      when(
        mockRemote.updateTask(any, any),
      ).thenThrow(Exception('network error'));

      when(mockQueue.update(any)).thenAnswer((_) async {});

      // Act
      await engine.run();

      // Assert
      verify(
        mockQueue.update(
          argThat(predicate<SyncQueueItem>((i) => i.retryCount == 1)),
        ),
      ).called(1);

      verifyNever(mockQueue.remove(any));
    });

    test('does nothing when queue is empty', () async {
      // Arrange
      when(mockQueue.getReadyItems(any)).thenAnswer((_) async => []);
      when(mockNetworkInfoImpl.isConnected).thenAnswer((_) async => true);

      // Act
      await engine.run();

      // Assert
      verifyNever(mockRemote.updateTask(any, any));
      verifyNever(mockRemote.createTask(any));
      verifyNever(mockLocal.upsertTask(any));
    });
  });
}
