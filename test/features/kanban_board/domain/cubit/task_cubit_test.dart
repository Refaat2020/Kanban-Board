import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/kanban_cubit.dart';
import 'package:kanban_board/features/kanban_board/domain/service/task_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_cubit_test.mocks.dart';

@GenerateMocks([
  TaskService,
])
void main() {
  late MockTaskService mockTaskService;
  const projectId = '123';

  setUp(() {
    mockTaskService = MockTaskService();
  });

  group(
    'KanbanCubit',
    () {
      blocTest<KanbanCubit, KanbanState>(
        'emits [KanbanLoading, KanbanEmptyTasks] when fetch tasks succeeds',
        build: () {
          const projectId = '123';
          when(mockTaskService.fetchTasks(projectId))
              .thenAnswer((_) async => []);

          return KanbanCubit(mockTaskService);
        },
        act: (bloc) async {
          await bloc.fetchTasks(projectId);
        },
        expect: () => [
          isA<KanbanLoading>(),
          isA<KanbanEmptyTasks>(),
        ],
      );

      blocTest<KanbanCubit, KanbanState>(
        'emits [KanbanLoading, KanbanEmptyTasks] when fetch tasks succeeds',
        build: () {
          const projectId = '123';
          final List<Task> fetchTasks = [
            Task(
              id: 'task1',
              content: 'Task 1',
              description: 'Task 1 description',
              projectId: projectId,
            ),
          ];
          when(mockTaskService.fetchTasks(projectId))
              .thenAnswer((_) async => fetchTasks);

          return KanbanCubit(mockTaskService);
        },
        act: (bloc) async {
          await bloc.fetchTasks(projectId);
        },
        expect: () => [
          isA<KanbanLoading>(),
          isA<KanbanTasksLoaded>(),
        ],
      );

      blocTest<KanbanCubit, KanbanState>(
        'emits [KanbanLoading, KanbanError] when  fetch tasks fail',
        build: () {
          const errorMessage = 'Project creation failed';

          when(mockTaskService.fetchTasks(projectId))
              .thenAnswer((_) async => Future.error(
                    FailureModel(
                      state: 400,
                      message: errorMessage,
                    ),
                  ));

          return KanbanCubit(mockTaskService);
        },
        act: (bloc) async {
          await bloc.fetchTasks(projectId);
        },
        expect: () => [
          isA<KanbanLoading>(),
          isA<KanbanError>(),
        ],
      );
    },
  );
}
