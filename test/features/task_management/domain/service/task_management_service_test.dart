import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';
import 'package:kanban_board/features/task_management/domain/usecases/create_task.dart';
import 'package:kanban_board/features/task_management/domain/usecases/update_task.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_management_service_test.mocks.dart';

@GenerateMocks([
  TaskManagementRepository,
])
void main() {
  late MockTaskManagementRepository mockTaskManagementRepository;

  late CreateTask createTask;
  late UpdateTask updateTask;

  setUp(() {
    mockTaskManagementRepository = MockTaskManagementRepository();

    createTask = CreateTask(mockTaskManagementRepository);
    updateTask = UpdateTask(mockTaskManagementRepository);
  });

  group(
    'TaskManagementService for createTask',
    () {
      test('createTask should return a task when success', () async {
        // Arrange
        final task = TaskModel(
          projectId: '123',
          content: 'content',
          description: 'description',
        );
        final responseTask = TaskModel(
            projectId: '123',
            content: 'content',
            description: 'description',
            id: '1');

        when(mockTaskManagementRepository.createTask(task)).thenAnswer(
          (_) async => responseTask,
        );

        // Act
        final result = await createTask.call(task);

        // Assert
        expect(result, isA<Task>());
        verify(mockTaskManagementRepository.createTask(task)).called(1);
      });

      test(
        'createTask should throw FailureModel if createTask fails',
        () async {
          // Arrange
          const errorMessage = "problem with creating task";
          final task = TaskModel(
            projectId: '123',
            content: 'content',
            description: 'description',
          );

          when(mockTaskManagementRepository.createTask(task))
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await createTask.call(task),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockTaskManagementRepository.createTask(task)).called(1);
        },
      );
    },
  );

  group(
    'TaskManagementService for updateTask',
    () {
      test('updateTask should return a task when success', () async {
        // Arrange
        const taskId = '123';
        final task = TaskModel(
          projectId: '123',
          content: 'content',
          id: '1',
          description: 'description',
        );
        final responseTask = TaskModel(
            projectId: '123',
            content: 'updatedContent',
            description: 'description',
            id: '1');

        when(mockTaskManagementRepository.updateTask(task, taskId)).thenAnswer(
          (_) async => responseTask,
        );

        // Act
        final result = await updateTask.call(task, taskId);

        // Assert
        expect(result, isA<Task>());
        verify(mockTaskManagementRepository.updateTask(task, taskId)).called(1);
      });

      test(
        'createTask should throw FailureModel if createTask fails',
        () async {
          // Arrange
          const taskId = '123';
          const errorMessage = "problem with creating task";
          final task = TaskModel(
            projectId: '123',
            content: 'content',
            description: 'description',
          );

          when(mockTaskManagementRepository.updateTask(task, taskId))
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await updateTask.call(task, taskId),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockTaskManagementRepository.updateTask(task, taskId))
              .called(1);
        },
      );
    },
  );
}
