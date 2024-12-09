import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskDataSource])
void main() {
  late MockTaskDataSource mockTaskDataSource;

  late TaskRepositoryImpl taskRepositoryImpl;

  setUp(() {
    mockTaskDataSource = MockTaskDataSource();

    taskRepositoryImpl = TaskRepositoryImpl(mockTaskDataSource);
  });

  group(
    'TaskRepositoryImpl',
    () {
      test('fetchTasks should return a list of tasks', () async {
        // Arrange
        const projectId = 'project-123';
        final mockResponse = [
          {'id': 'task-1', 'name': 'Task 1'},
          {'id': 'task-2', 'name': 'Task 2'},
        ];
        when(mockTaskDataSource.fetchTasks(projectId)).thenAnswer((_) async =>
            mockResponse); // Mocking the response from the data source

        // Act
        final result = await taskRepositoryImpl.fetchTasks(projectId);

        // Assert
        expect(result, isA<List<Task>>());
        expect(result.length, 2);
        expect(result[0].id, 'task-1');
        expect(result[1].id, 'task-2');
        verify(mockTaskDataSource.fetchTasks(projectId)).called(1);
      });

      test(
          'fetchTasks should throw FailureModel when data source throws FailureModel',
          () async {
        // Arrange
        const projectId = 'project-123';
        when(mockTaskDataSource.fetchTasks(projectId)).thenThrow(FailureModel(
          state: 0,
          message: 'Failed to fetch tasks',
        ));

        // Act & Assert
        expect(
          () async => await taskRepositoryImpl.fetchTasks(projectId),
          throwsA(isA<FailureModel>()
              .having((e) => e.message, 'message', 'Failed to fetch tasks')),
        );
        verify(mockTaskDataSource.fetchTasks(projectId)).called(1);
      });
      test('fetchTasks should throw FailureModel on unexpected error',
          () async {
        // Arrange
        const projectId = 'project-123';
        const errorMessage = 'Unexpected error';
        when(mockTaskDataSource.fetchTasks(projectId))
            .thenThrow(FailureModel(message: errorMessage, state: 0));

        // Act & Assert
        expect(
          () async => await taskRepositoryImpl.fetchTasks(projectId),
          throwsA(isA<FailureModel>()
              .having((e) => e.message, 'message', errorMessage)),
        );
        verify(mockTaskDataSource.fetchTasks(projectId)).called(1);
      });
    },
  );
}
