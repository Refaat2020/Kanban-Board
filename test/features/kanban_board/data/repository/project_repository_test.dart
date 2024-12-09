import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'project_repository_test.mocks.dart';

@GenerateMocks([ProjectDataSource, PreferenceStorage])
void main() {
  late MockProjectDataSource mockProjectDataSource;
  late MockPreferenceStorage mockPreferenceStorage;

  late ProjectRepositoryImpl projectRepositoryImpl;

  setUp(() {
    mockPreferenceStorage = MockPreferenceStorage();
    locator.registerSingleton<PreferenceStorage>(mockPreferenceStorage);

    mockProjectDataSource = MockProjectDataSource();
    locator.registerSingleton<ProjectDataSource>(mockProjectDataSource);

    projectRepositoryImpl = ProjectRepositoryImpl(mockProjectDataSource);
  });
  tearDown(
    () => locator.reset(dispose: true),
  );
  group(
    'ProjectRepositoryImpl',
    () {
      test('getOrCreateDefaultProject should return existing project ID',
          () async {
        // Arrange
        const existingProjectId = 'existing-project-id';
        when(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
            .thenReturn(existingProjectId);

        // Act
        final result = await projectRepositoryImpl.getOrCreateDefaultProject();

        // Assert
        expect(result, existingProjectId);
        verify(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
            .called(1);
        verifyNever(mockProjectDataSource.createProject(any));
      });
      test(
          'getOrCreateDefaultProject should create a new project if no existing project ID',
          () async {
        // Arrange
        const projectId = 'new-project-id';
        when(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
            .thenReturn(null);
        when(mockProjectDataSource.createProject(any))
            .thenAnswer((_) async => projectId);
        when(mockPreferenceStorage.setString(
                AppKeys.defaultProjectKey, projectId))
            .thenAnswer((_) async => true);

        // Act
        final result = await projectRepositoryImpl.getOrCreateDefaultProject();

        // Assert
        expect(result, projectId);
        verify(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
            .called(1);
        verify(mockProjectDataSource.createProject(any)).called(1);
        verify(mockPreferenceStorage.setString(
                AppKeys.defaultProjectKey, projectId))
            .called(1);
      });
      test(
        'getOrCreateDefaultProject should throw FailureModel if createProject fails',
        () async {
          // Arrange
          const errorMessage = 'Project creation failed';
          when(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
              .thenReturn(null); // No existing project ID
          when(mockProjectDataSource.createProject(any))
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await projectRepositoryImpl.getOrCreateDefaultProject(),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
              .called(1);
          verify(mockProjectDataSource.createProject(any)).called(1);
          verifyNever(
              mockPreferenceStorage.setString(AppKeys.defaultProjectKey, any));
        },
      );
    },
  );
}
