import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/service/dio_service_test.mocks.dart';

void main() {
  late MockDioClient mockDioClient;
  late ProjectDataSourceImpl projectDataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    projectDataSource = ProjectDataSourceImpl(mockDioClient);
  });

  group('ProjectDataSourceImpl', () {
    test('createProject should return project ID on success', () async {
      // Arrange
      const projectName = 'Test Project';
      const projectId = '123';
      when(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .thenAnswer((_) async => {'id': projectId});

      // Act
      final result = await projectDataSource.createProject(projectName);

      // Assert
      expect(result, projectId);
      verify(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .called(1);
    });

    test('createProject should throw FailureModel on FailureModel exception',
        () async {
      // Arrange
      const projectName = 'Test Project';
      final failure = FailureModel(state: 1, message: 'Error creating project');
      when(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .thenThrow(failure);

      // Act & Assert
      expect(
        () => projectDataSource.createProject(projectName),
        throwsA(isA<FailureModel>()),
      );
      verify(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .called(1);
    });

    test('createProject should throw FailureModel on unexpected exception',
        () async {
      // Arrange
      const projectName = 'Test Project';
      const unexpectedError = 'Unexpected Error';
      when(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .thenThrow(FailureModel(message: unexpectedError, state: 0));

      // Act & Assert
      expect(
        () async => await projectDataSource.createProject(projectName),
        throwsA(isA<FailureModel>()
            .having((e) => e.message, 'message', unexpectedError)),
      );
      verify(mockDioClient
              .postRequest({'name': projectName}, AppUrl.postCreateProject))
          .called(1);
    });
  });
}
