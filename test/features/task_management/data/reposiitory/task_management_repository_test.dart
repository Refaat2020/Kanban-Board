import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/core/sync/data/data_source/sync_queue_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/task_local_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_local_model.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_management_repository_test.mocks.dart';

@GenerateMocks([TaskLocalDataSource, SyncQueueDataSource])
void main() {
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late MockSyncQueueDataSource mockSyncQueueDataSource;

  late TaskManagementRepositoryImpl taskManagementRepositoryImpl;

  setUp(() {
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    mockSyncQueueDataSource = MockSyncQueueDataSource();
    taskManagementRepositoryImpl = TaskManagementRepositoryImpl(
      mockTaskLocalDataSource,
      mockSyncQueueDataSource,
    );
  });

  group('test TaskManagementRepositoryImpl createTask', () {
    test('createTask should return Task when success', () async {
      // Arrange
      final mockResponse = {
        "content": "test",
        "description": "description",
        "project_id": "123",
        "task_id": "123",
      };
      final task = Task(
        content: "test",
        description: "description",
        projectId: "123",
      );
      final localTask = TaskLocalModel.fromEntity(task, isSynced: false);

      when(
        mockTaskLocalDataSource.upsertTask(localTask),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await taskManagementRepositoryImpl.createTask(task);

      // Assert
      expect(result, isA<Task>());
      verify(
        mockTaskLocalDataSource.upsertTask(
          argThat(
            predicate<TaskLocalModel>(
              (t) =>
                  t.content == 'test' &&
                  t.description == 'description' &&
                  t.projectId == '123' &&
                  t.isSynced == false,
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('test CommentRepositoryImpl updateTask', () {
    test('updateTask should return Task when success', () async {
      // Arrange
      const taskId = "123";

      final mockResponse = {
        "content": "test",
        "description": "description",
        "project_id": "123",
        "id": "123",
      };

      final task = Task(
        id: "123",
        content: "test",
        description: "description",
        projectId: "123",
        sectionId: 1,
        order: 0,
        priority: 1,
        isCompleted: false,
      );

      when(
        mockTaskLocalDataSource.upsertTask(any),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await taskManagementRepositoryImpl.updateTask(
        task,
        taskId,
      );

      // Assert
      expect(result, isA<Task>());
      expect(result.id, "123");
      expect(result.content, "test");

      verify(mockTaskLocalDataSource.upsertTask(any)).called(1);
    });
  });
}
