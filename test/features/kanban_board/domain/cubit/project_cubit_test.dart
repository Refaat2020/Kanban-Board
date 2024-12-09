import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/project_cubit.dart';
import 'package:kanban_board/features/kanban_board/domain/service/project_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'project_cubit_test.mocks.dart';

@GenerateMocks([
  ProjectService,
])
void main() {
  late MockProjectService mockProjectService;

  setUp(() {
    mockProjectService = MockProjectService();
  });

  group(
    'ProjectCubit',
    () {
      blocTest<ProjectCubit, ProjectState>(
        'emits [ProjectLoading, ProjectLoaded] when create Project succeeds',
        build: () {
          when(mockProjectService.getOrCreateDefaultProject())
              .thenAnswer((_) async => "123");

          return ProjectCubit(mockProjectService);
        },
        act: (bloc) async {
          await bloc.getOrCreateProject();
        },
        expect: () => [
          isA<ProjectLoading>(),
          isA<ProjectLoaded>(),
        ],
      );

      blocTest<ProjectCubit, ProjectState>(
        'emits [ProjectLoading, ProjectError] when create Project fails',
        build: () {
          const errorMessage = 'Project creation failed';

          when(mockProjectService.getOrCreateDefaultProject())
              .thenAnswer((_) async => Future.error(
                    FailureModel(
                      state: 400,
                      message: errorMessage,
                    ),
                  ));

          return ProjectCubit(mockProjectService);
        },
        act: (bloc) async {
          await bloc.getOrCreateProject();
        },
        expect: () => [
          isA<ProjectLoading>(),
          isA<ProjectError>().having((state) => state.errorMessage, 'message',
              'Project creation failed'),
        ],
      );
    },
  );
}
