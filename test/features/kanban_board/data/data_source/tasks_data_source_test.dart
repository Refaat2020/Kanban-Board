import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/service/dio_service_test.mocks.dart';

void main() {
  late MockDioClient mockDioClient;
  late TasksDataSourceImpl tasksDataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    tasksDataSource = TasksDataSourceImpl(mockDioClient);
  });

  group(
    'TasksDataSourceImpl & fetchTasks',
    () {
      test(
        'fetchTasks should return a List on success',
        () async {
          // Arrange
          const projectId = '123';
          when(mockDioClient.getRequest(AppUrl.getTasks,
              prams: {'project_id': projectId})).thenAnswer((_) async => []);

          // Act
          final result = await tasksDataSource.fetchTasks(projectId);

          // Assert
          expect(result, []);
          verify(mockDioClient.getRequest(AppUrl.getTasks,
              prams: {'project_id': projectId})).called(1);
        },
      );

      test(
        'fetchTasks  should throw FailureModel on FailureModel exception',
        () async {
          // Arrange
          const projectId = '123';
          final failure = FailureModel(
              state: 1, message: 'this project $projectId not found');
          when(mockDioClient.getRequest(AppUrl.getTasks,
              prams: {'project_id': projectId})).thenThrow(failure);

          // Act & Assert
          expect(
            () => tasksDataSource.fetchTasks(projectId),
            throwsA(isA<FailureModel>()),
          );
          verify(mockDioClient.getRequest(AppUrl.getTasks,
              prams: {'project_id': projectId})).called(1);
        },
      );
    },
  );
}
