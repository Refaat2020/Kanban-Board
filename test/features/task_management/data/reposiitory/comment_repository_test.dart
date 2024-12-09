import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source.dart';
import 'package:kanban_board/features/task_management/data/models/comment.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comment_repository_test.mocks.dart';

@GenerateMocks([CommentDataSource])
void main() {
  late MockCommentDataSource mockTaskDataSource;

  late CommentRepositoryImpl commentRepositoryImpl;

  setUp(() {
    mockTaskDataSource = MockCommentDataSource();

    commentRepositoryImpl = CommentRepositoryImpl(mockTaskDataSource);
  });

  group(
    'test CommentRepositoryImpl fetchComments',
    () {
      test(
        'fetchComments should return an empty list',
        () async {
          // Arrange
          const taskId = '123';
          final mockResponse = [];
          when(mockTaskDataSource.fetchComments(taskId))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await commentRepositoryImpl.fetchComments(taskId);

          // Assert
          expect(result, []);
          expect(result.length, 0);
          verify(mockTaskDataSource.fetchComments(taskId)).called(1);
        },
      );

      test(
        'fetchComments should return a list',
        () async {
          // Arrange
          const taskId = '123';
          final mockResponse = [
            {"task_id": "123", "content": "content", "id": "1"},
            {"task_id": "123", "content": "content", "id": "1"},
            {"task_id": "123", "content": "content", "id": "1"},
          ];
          when(mockTaskDataSource.fetchComments(taskId))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await commentRepositoryImpl.fetchComments(taskId);

          // Assert
          expect(result, isA<List<Comment>>());
          expect(result.length, 3);
          expect(result[0].id, '1');
          verify(mockTaskDataSource.fetchComments(taskId)).called(1);
        },
      );

      test(
        'fetchComments should throw FailureModel when data source throws FailureModel',
        () async {
          // Arrange
          const taskId = '123';
          when(mockTaskDataSource.fetchComments(taskId)).thenThrow(
            FailureModel(
              state: 0,
              message: 'Failed to fetch comment for tis task',
            ),
          );

          // Act & Assert
          expect(
            () async => await commentRepositoryImpl.fetchComments(taskId),
            throwsA(isA<FailureModel>().having((e) => e.message, 'message',
                'Failed to fetch comment for tis task')),
          );
          verify(mockTaskDataSource.fetchComments(taskId)).called(1);
        },
      );
    },
  );

  group(
    'test CommentRepositoryImpl addComment',
    () {
      test(
        'addComment should return a comment when success',
        () async {
          // Arrange
          const mocRequestData = {
            "content": "test",
            "task_id": "123",
          };
          const mocResponseData = {
            "content": "test",
            "task_id": "123",
            "id": "1"
          };
          final mockComment = Comment(content: 'test', taskId: "123");
          when(mockTaskDataSource.addComment(mocRequestData))
              .thenAnswer((_) async => mocResponseData);

          // Act
          final result = await commentRepositoryImpl.addComment(mockComment);

          // Assert
          expect(result, isA<Comment>());

          verify(mockTaskDataSource.addComment(mocRequestData)).called(1);
        },
      );

      test(
        'addComment should throw FailureModel when data source throws FailureModel',
        () async {
          // Arrange
          const mocRequestData = {
            "content": "test",
            "task_id": "123",
          };
          final mockComment = Comment(content: 'test', taskId: "123");

          when(mockTaskDataSource.addComment(mocRequestData)).thenThrow(
            FailureModel(
              state: 0,
              message: 'Failed to add comment to tis task',
            ),
          );

          // Act & Assert
          expect(
            () async => await commentRepositoryImpl.addComment(mockComment),
            throwsA(isA<FailureModel>().having((e) => e.message, 'message',
                'Failed to add comment to tis task')),
          );
          verify(mockTaskDataSource.addComment(mocRequestData)).called(1);
        },
      );
    },
  );
}
