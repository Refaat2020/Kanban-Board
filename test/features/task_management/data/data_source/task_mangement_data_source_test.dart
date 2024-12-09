import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/service/dio_service_test.mocks.dart';

void main() {
  late MockDioClient mockDioClient;
  late TaskManagementDataSourceImpl taskManagementDataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    taskManagementDataSource = TaskManagementDataSourceImpl(mockDioClient);
  });

  group(
    'test TaskManagementDataSourceImpl createTask',
    () {
      test(
        'createTask should return a Map on success',
        () async {
          // Arrange
          const requestBody = {
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          const requestResponse = {
            'task_id': '1',
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postCreateTask,
            ),
          ).thenAnswer((_) async => requestResponse);

          // Act
          final result = await taskManagementDataSource.createTask(requestBody);

          // Assert
          expect(result, requestResponse);
          verify(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postCreateTask,
            ),
          ).called(1);
        },
      );

      test(
        'createTask should throw FailureModel on unexpected exception',
        () async {
          // Arrange
          const requestBody = {
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          const unexpectedError = 'Unexpected Error';
          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postCreateTask,
            ),
          ).thenThrow(FailureModel(message: unexpectedError, state: 0));

          // Act & Assert
          expect(
            () async => await taskManagementDataSource.createTask(requestBody),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', unexpectedError)),
          );
          verify(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postCreateTask,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'test TaskManagementDataSourceImpl updateTask',
    () {
      test(
        'updateTask should return a Map on success',
        () async {
          const taskId = '123';
          // Arrange
          const requestBody = {
            'task_id': '1',
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          const requestResponse = {
            'task_id': '1',
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postUpdateTask(taskId),
            ),
          ).thenAnswer((_) async => requestResponse);

          // Act
          final result =
              await taskManagementDataSource.updateTask(requestBody, taskId);

          // Assert
          expect(result, requestResponse);
          verify(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postUpdateTask(taskId),
            ),
          ).called(1);
        },
      );

      test(
        'updateTask should throw FailureModel on unexpected exception',
        () async {
          const taskId = '123';

          // Arrange
          const requestBody = {
            'project_id': '1',
            'content': 'content',
            'description': 'description'
          };
          const unexpectedError = 'Unexpected Error';
          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postUpdateTask(taskId),
            ),
          ).thenThrow(FailureModel(message: unexpectedError, state: 0));

          // Act & Assert
          expect(
            () async =>
                await taskManagementDataSource.updateTask(requestBody, taskId),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', unexpectedError)),
          );
          verify(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postUpdateTask(taskId),
            ),
          ).called(1);
        },
      );
    },
  );
}
