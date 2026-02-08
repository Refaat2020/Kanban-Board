import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_board/features/kanban_board/domain/usecases/fetch_tasks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_service_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockTaskRepository;

  late FetchTasks taskService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();

    taskService = FetchTasks(mockTaskRepository);
  });

  group(
    'TaskServicew',
    () {
      test('fetchTasks should return a list of tasks', () async {
        // Arrange
        const projectId = 'project-123';
        final mockResponse = [
          Task(content: '', description: '', order: 1),
          Task(content: '', description: '', order: 1),
        ];
        when(mockTaskRepository.fetchTasks(projectId))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await taskService.call(projectId);

        // Assert
        expect(result, isA<List<Task>>());
        expect(result.length, 2);
        expect(result[0].content, '');
        expect(result[1].order, 1);
        verify(mockTaskRepository.fetchTasks(projectId)).called(1);
      });

      test(
          'fetchTasks should throw FailureModel when data source throws FailureModel',
          () async {
        // Arrange
        const projectId = 'project-123';
        when(mockTaskRepository.fetchTasks(projectId)).thenThrow(FailureModel(
          state: 0,
          message: 'Failed to fetch tasks',
        ));

        // Act & Assert
        expect(
          () async => await taskService.call(projectId),
          throwsA(isA<FailureModel>()
              .having((e) => e.message, 'message', 'Failed to fetch tasks')),
        );
        verify(mockTaskRepository.fetchTasks(projectId)).called(1);
      });
      test('fetchTasks should throw FailureModel on unexpected error',
          () async {
        // Arrange
        const projectId = 'project-123';
        const errorMessage = 'Unexpected error';
        when(mockTaskRepository.fetchTasks(projectId))
            .thenThrow(FailureModel(message: errorMessage, state: 0));

        // Act & Assert
        expect(
          () async => await taskService.call(projectId),
          throwsA(isA<FailureModel>()
              .having((e) => e.message, 'message', errorMessage)),
        );
        verify(mockTaskRepository.fetchTasks(projectId)).called(1);
      });
    },
  );
}
