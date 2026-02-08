import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository.dart';
import 'package:kanban_board/features/kanban_board/domain/usecases/get_or_create_default_project.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'project_service_test.mocks.dart';

@GenerateMocks([
  ProjectRepository,
])
void main() {
  late MockProjectRepository mockProjectRepository;

  late GetOrCreateDefaultProject projectService;

  setUp(() {
    mockProjectRepository = MockProjectRepository();

    projectService = GetOrCreateDefaultProject(mockProjectRepository);
  });

  group(
    'ProjectService',
    () {
      test('getOrCreateDefaultProject should return existing project ID',
          () async {
        // Arrange
        const existingProjectId = 'existing-project-id';
        when(mockProjectRepository.getOrCreateDefaultProject()).thenAnswer(
          (_) async => existingProjectId,
        );

        // Act
        final result = await projectService.call();

        // Assert
        expect(result, existingProjectId);
        verify(mockProjectRepository.getOrCreateDefaultProject()).called(1);
      });

      test(
        'getOrCreateDefaultProject should throw FailureModel if createProject fails',
        () async {
          // Arrange
          const errorMessage = 'Project creation failed';
          when(mockProjectRepository.getOrCreateDefaultProject())
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await projectService.call(),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockProjectRepository.getOrCreateDefaultProject()).called(1);
        },
      );
    },
  );
}
