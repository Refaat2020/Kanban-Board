import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/domain/usecases/get_or_create_default_project.dart';
import 'package:kanban_board/features/kanban_board/presentation/cubit/project_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'project_cubit_test.mocks.dart';

@GenerateMocks([
  GetOrCreateDefaultProject,
])
void main() {
  late MockGetOrCreateDefaultProject mockProjectService;

  setUp(() {
    mockProjectService = MockGetOrCreateDefaultProject();
  });

  group(
    'ProjectCubit',
    () {
      blocTest<ProjectCubit, ProjectState>(
        'emits [ProjectLoading, ProjectLoaded] when create Project succeeds',
        build: () {
          when(mockProjectService.call())
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

          when(mockProjectService.call())
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
