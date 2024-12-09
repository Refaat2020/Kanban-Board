import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/features/task_management/domain/service/task_management_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_managment_cubit_test.mocks.dart';

@GenerateMocks([
  TaskManagementService,
])
void main() {
  late MockTaskManagementService mockTaskManagementService;
  final task = Task(content: 'This is a task', description: 'test');
  final responseTask =
      Task(content: 'This is a task', description: 'test', id: '1');

  setUp(() {
    mockTaskManagementService = MockTaskManagementService();
  });

  group(
    'TaskManagementCubit  create Task',
    () {
      blocTest<TaskManagementCubit, TaskManagementState>(
        'emits [TaskManagementLoading, TaskManagementDone] when create task succeeds',
        build: () {
          when(mockTaskManagementService.createTask(task))
              .thenAnswer((_) async => responseTask);

          return TaskManagementCubit(mockTaskManagementService);
        },
        act: (bloc) async {
          await bloc.createTask(responseTask);
        },
        expect: () => [
          isA<TaskManagementLoading>(),
          isA<TaskManagementDone>(),
        ],
      );

      blocTest<TaskManagementCubit, TaskManagementState>(
        'emits [TaskManagementLoading, TaskManagementDone] when create task fails',
        build: () {
          const errorMessage = 'create task failed';

          when(mockTaskManagementService.createTask(task)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return TaskManagementCubit(mockTaskManagementService);
        },
        act: (bloc) async {
          await bloc.createTask(task);
        },
        expect: () => [
          isA<TaskManagementLoading>(),
          isA<TaskManagementError>().having(
              (state) => state.errorMessage, 'message', 'create task failed'),
        ],
      );
    },
  );

  group(
    'TaskManagementCubit  update Task',
    () {
      blocTest<TaskManagementCubit, TaskManagementState>(
        'emits [TaskManagementLoading, TaskManagementUpdatedDone] when update task succeeds',
        build: () {
          when(mockTaskManagementService.updateTask(any, any))
              .thenAnswer((_) async => responseTask);

          return TaskManagementCubit(mockTaskManagementService);
        },
        act: (bloc) async {
          await bloc.updateTask(responseTask);
        },
        expect: () => [
          isA<TaskManagementLoading>(),
          isA<TaskManagementUpdatedDone>(),
        ],
      );

      blocTest<TaskManagementCubit, TaskManagementState>(
        'emits [TaskManagementLoading, TaskManagementError] when update task fails',
        build: () {
          const errorMessage = 'update task failed';

          when(mockTaskManagementService.updateTask(any, any)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return TaskManagementCubit(mockTaskManagementService);
        },
        act: (bloc) async {
          await bloc.updateTask(responseTask);
        },
        expect: () => [
          isA<TaskManagementLoading>(),
          isA<TaskManagementError>().having(
              (state) => state.errorMessage, 'message', 'update task failed'),
        ],
      );
    },
  );
}
