import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_management_repository_test.mocks.dart';

@GenerateMocks([TaskManagementDataSource])
void main() {
  late MockTaskManagementDataSource mockTaskDataSource;

  late TaskManagementRepositoryImpl taskManagementRepositoryImpl;

  setUp(() {
    mockTaskDataSource = MockTaskManagementDataSource();

    taskManagementRepositoryImpl =
        TaskManagementRepositoryImpl(mockTaskDataSource);
  });

  group(
    'test TaskManagementRepositoryImpl createTask',
    () {
      test(
        'createTask should return Task when success',
        () async {
          // Arrange
          const mockRequest = {
            "content": "test",
            "description": "description",
            "project_id": "123"
          };
          final mockResponse = {
            "content": "test",
            "description": "description",
            "project_id": "123",
            "task_id": "123"
          };
          final task = Task(
            content: "test",
            description: "description",
            projectId: "123",
          );
          when(mockTaskDataSource.createTask(mockRequest))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await taskManagementRepositoryImpl.createTask(task);

          // Assert
          expect(result, isA<Task>());

          verify(mockTaskDataSource.createTask(mockRequest)).called(1);
        },
      );

      test(
        'createTask should throw FailureModel when data source throws FailureModel',
        () async {
          // Arrange
          const mockRequest = {
            "content": "test",
            "description": "description",
            "project_id": "123"
          };
          final task = Task(
            content: "test",
            description: "description",
            projectId: "123",
          );
          when(mockTaskDataSource.createTask(mockRequest)).thenThrow(
            FailureModel(
              state: 0,
              message: 'Failed to create task',
            ),
          );

          // Act & Assert
          expect(
            () async => await taskManagementRepositoryImpl.createTask(task),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', 'Failed to create task')),
          );
          verify(mockTaskDataSource.createTask(mockRequest)).called(1);
        },
      );
    },
  );

  group(
    'test CommentRepositoryImpl updateTask',
    () {
      test(
        'updateTask should return Task when success',
        () async {
          // Arrange
          const taskId = "123";
          const mockRequest = {
            "content": "test",
            "description": "description",
            "project_id": "123"
          };
          final mockResponse = {
            "content": "test",
            "description": "description",
            "project_id": "123",
            "id": "123"
          };
          final task = Task(
            content: "test",
            description: "description",
            id: "123",
            projectId: "123",
          );

          when(mockTaskDataSource.updateTask(mockRequest, taskId))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result =
              await taskManagementRepositoryImpl.updateTask(task, taskId);

          // Assert
          expect(result, isA<Task>());

          verify(mockTaskDataSource.updateTask(mockRequest, taskId)).called(1);
        },
      );

      test(
        'updateTask should throw FailureModel when data source throws FailureModel',
        () async {
          // Arrange
          const taskId = "123";
          const mockRequest = {
            "content": "test",
            "description": "description",
            "project_id": "123"
          };
          final task = Task(
            content: "test",
            description: "description",
            id: "123",
            projectId: "123",
          );

          when(mockTaskDataSource.updateTask(mockRequest, taskId)).thenThrow(
            FailureModel(
              state: 0,
              message: 'Failed to update task',
            ),
          );

          // Act & Assert
          expect(
            () async =>
                await taskManagementRepositoryImpl.updateTask(task, taskId),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', 'Failed to update task')),
          );
          verify(mockTaskDataSource.updateTask(mockRequest, taskId)).called(1);
        },
      );
    },
  );
}
