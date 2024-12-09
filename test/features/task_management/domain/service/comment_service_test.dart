import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/task_management/data/models/comment.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository.dart';
import 'package:kanban_board/features/task_management/domain/service/comment_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comment_service_test.mocks.dart';

@GenerateMocks([
  CommentRepository,
])
void main() {
  late MockCommentRepository mockCommentRepository;

  late CommentService commentService;

  setUp(() {
    mockCommentRepository = MockCommentRepository();

    commentService = CommentService(mockCommentRepository);
  });

  group(
    'CommentService for fetchComments',
    () {
      test('fetchComments should return an empty list when success', () async {
        // Arrange
        const taskId = '123';

        when(mockCommentRepository.fetchComments(taskId)).thenAnswer(
          (_) async => [],
        );

        // Act
        final result = await commentService.fetchComments(taskId);

        // Assert
        expect(result, []);
        verify(mockCommentRepository.fetchComments(taskId)).called(1);
      });

      test('fetchComments should return an  list when success', () async {
        // Arrange
        const taskId = '123';
        final comments = [Comment(id: '456', content: 'Hello, world!')];

        when(mockCommentRepository.fetchComments(taskId)).thenAnswer(
          (_) async => comments,
        );

        // Act
        final result = await commentService.fetchComments(taskId);

        // Assert
        expect(result, comments);
        verify(mockCommentRepository.fetchComments(taskId)).called(1);
      });

      test(
        'fetchComments should throw FailureModel if fetchComments fails',
        () async {
          // Arrange
          const errorMessage = "problem with fetchComments";
          const taskId = '123';

          when(mockCommentRepository.fetchComments(taskId))
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await commentService.fetchComments(taskId),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockCommentRepository.fetchComments(taskId)).called(1);
        },
      );
    },
  );

  group(
    'CommentService for addComment',
    () {
      test('addComment should return a comment when success', () async {
        // Arrange
        final comment = Comment(
          content: "content",
          taskId: "123",
        );
        final createdComment =
            Comment(content: "content", taskId: "123", id: '1');

        when(mockCommentRepository.addComment(comment)).thenAnswer(
          (_) async => createdComment,
        );

        // Act
        final result = await commentService.addComment(comment);

        // Assert
        expect(result, isA<Comment>());
        verify(mockCommentRepository.addComment(comment)).called(1);
      });

      test(
        'addComment should throw FailureModel if addComment fails',
        () async {
          // Arrange
          const errorMessage = "problem with adding comment";
          final comment = Comment(
            content: "content",
            taskId: "123",
          );

          when(mockCommentRepository.addComment(comment))
              .thenThrow(FailureModel(state: 0, message: errorMessage));

          // Act & Assert
          expect(
            () async => await commentService.addComment(comment),
            throwsA(isA<FailureModel>()
                .having((e) => e.message, 'message', errorMessage)),
          );
          verify(mockCommentRepository.addComment(comment)).called(1);
        },
      );
    },
  );
}
