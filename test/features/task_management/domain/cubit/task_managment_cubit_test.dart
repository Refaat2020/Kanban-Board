import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/task_management/domain/usecases/create_task.dart';
import 'package:kanban_board/features/task_management/domain/usecases/update_task.dart';
import 'package:kanban_board/features/task_management/presentation/cubit/task_management_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_managment_cubit_test.mocks.dart';

@GenerateMocks([
  CreateTask,
  UpdateTask,
])
void main() {
  late MockCreateTask mockCreateTask;
  late MockUpdateTask mockUpdateTask;
  final task = TaskModel(content: 'This is a task', description: 'test');
  final responseTask =
      TaskModel(content: 'This is a task', description: 'test', id: '1');

  setUp(() {
    mockCreateTask = MockCreateTask();
    mockUpdateTask = MockUpdateTask();
  });

  group(
    'TaskManagementCubit  create Task',
    () {
      blocTest<TaskManagementCubit, TaskManagementState>(
        'emits [TaskManagementLoading, TaskManagementDone] when create task succeeds',
        build: () {
          when(mockCreateTask.call(task))
              .thenAnswer((_) async => responseTask);

          return TaskManagementCubit(mockCreateTask,mockUpdateTask);
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

          when(mockCreateTask.call(task)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return TaskManagementCubit(mockCreateTask,mockUpdateTask);
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
          when(mockUpdateTask.call(any, any))
              .thenAnswer((_) async => responseTask);

          return TaskManagementCubit(mockCreateTask,mockUpdateTask);
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

          when(mockUpdateTask.call(any, any)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return TaskManagementCubit(mockCreateTask,mockUpdateTask);
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
