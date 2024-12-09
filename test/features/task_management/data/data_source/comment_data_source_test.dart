import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/service/dio_service_test.mocks.dart';

void main() {
  late MockDioClient mockDioClient;
  late CommentDataSourceImpl commentDataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    commentDataSource = CommentDataSourceImpl(mockDioClient);
  });

  group(
    'test CommentDataSourceImpl fetch comments',
    () {
      test(
        'fetchComments should return a empty list on success',
        () async {
          // Arrange
          const taskId = '123';
          const prams = {'task_id': taskId};
          const listOfComments = [];
          when(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
              .thenAnswer((_) async => listOfComments);

          // Act
          final result = await commentDataSource.fetchComments(taskId);

          // Assert
          expect(result, listOfComments);
          verify(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
              .called(1);
        },
      );

      test('fetchComments should return a list on success', () async {
        // Arrange
        const taskId = '123';
        const prams = {'task_id': taskId};
        const listOfComments = [
          {"content": "content", "task_id": "1"},
          {"content": "content", "task_id": "2"},
        ];
        when(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
            .thenAnswer((_) async => listOfComments);

        // Act
        final result = await commentDataSource.fetchComments(taskId);

        // Assert
        expect(result, listOfComments);
        verify(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
            .called(1);
      });

      test(
        'fetchComments should throw FailureModel on unexpected exception',
        () async {
          // Arrange
          const taskId = '123';
          const prams = {'task_id': taskId};
          const unexpectedError = 'Unexpected Error';
          when(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
              .thenThrow(FailureModel(message: unexpectedError, state: 0));

          // Act & Assert
          expect(
            () async => await commentDataSource.fetchComments(taskId),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', unexpectedError)),
          );
          verify(mockDioClient.getRequest(AppUrl.postAddComment, prams: prams))
              .called(1);
        },
      );
    },
  );

  group(
    'test CommentDataSourceImpl add comment',
    () {
      test(
        'addComment should return a Map on success',
        () async {
          // Arrange
          const requestBody = {"content": "content", "task_id": "1"};
          const requestResponse = {
            "content": "content",
            "task_id": "1",
            "id": 1
          };

          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postAddComment,
            ),
          ).thenAnswer((_) async => requestResponse);

          // Act
          final result = await commentDataSource.addComment(requestBody);

          // Assert
          expect(
            result,
            requestResponse,
          );
          verify(mockDioClient.postRequest(
            requestBody,
            AppUrl.postAddComment,
          )).called(1);
        },
      );

      test(
        'addComment should throw FailureModel on unexpected exception',
        () async {
          // Arrange
          const requestBody = {"content": "content", "task_id": "1"};

          const unexpectedError = 'Unexpected Error';
          when(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postAddComment,
            ),
          ).thenThrow(FailureModel(message: unexpectedError, state: 0));

          // Act & Assert
          expect(
            () async => await commentDataSource.addComment(requestBody),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', unexpectedError)),
          );
          verify(
            mockDioClient.postRequest(
              requestBody,
              AppUrl.postAddComment,
            ),
          ).called(1);
        },
      );
    },
  );
}
