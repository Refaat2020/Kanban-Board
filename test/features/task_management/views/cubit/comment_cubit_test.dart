import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/task_management/data/models/comment_model.dart';
import 'package:kanban_board/features/task_management/domain/entities/comment.dart';
import 'package:kanban_board/features/task_management/domain/usecases/add_comment.dart';
import 'package:kanban_board/features/task_management/domain/usecases/fetch_comments.dart';
import 'package:kanban_board/features/task_management/presentation/cubit/comment_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comment_cubit_test.mocks.dart';

@GenerateMocks([
  AddComment,
  FetchComments,
])
void main() {
  late MockAddComment mockAddComment;
  late MockFetchComments mockFetchComments;
  const taskId = '123';
  final comment = CommentModel(taskId: '123', content: 'This is a comment');
  final responseComment =
      Comment(taskId: '123', content: 'This is a comment', id: '1');
  setUp(() {
    mockAddComment = MockAddComment();
    mockFetchComments=MockFetchComments();
  });

  group(
    'CommentCubit  fetch comments',
    () {
      blocTest<CommentCubit, CommentState>(
        'emits [CommentLoading, CommentsEmpty] when fetch comments succeeds',
        build: () {
          when(mockFetchComments.call(taskId))
              .thenAnswer((_) async => []);

          return CommentCubit(mockFetchComments,mockAddComment);
        },
        act: (bloc) async {
          await bloc.fetchComments(taskId);
        },
        expect: () => [
          isA<CommentLoading>(),
          isA<CommentsEmpty>(),
        ],
      );

      blocTest<CommentCubit, CommentState>(
        'emits [CommentLoading, CommentLoaded] when fetch comments succeeds',
        build: () {
          final mockResponse = [
            Comment(id: '1', content: 'This is a comment', taskId: taskId),
            Comment(id: '2', content: 'This is a comment', taskId: taskId),
            Comment(id: '3', content: 'This is a comment', taskId: taskId),
          ];
          when(mockFetchComments.call(taskId))
              .thenAnswer((_) async => mockResponse);

          return CommentCubit(mockFetchComments,mockAddComment);
        },
        act: (bloc) async {
          await bloc.fetchComments(taskId);
        },
        expect: () => [
          isA<CommentLoading>(),
          isA<CommentLoaded>(),
        ],
      );

      blocTest<CommentCubit, CommentState>(
        'emits [CommentLoading, CommentError] when fetch comments fails',
        build: () {
          const errorMessage = 'fetch comments failed';

          when(mockFetchComments.call(taskId)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return CommentCubit(mockFetchComments,mockAddComment);
        },
        act: (bloc) async {
          await bloc.fetchComments(taskId);
        },
        expect: () => [
          isA<CommentLoading>(),
          isA<CommentError>().having((state) => state.errorMessage, 'message',
              'fetch comments failed'),
        ],
      );
    },
  );

  group(
    'CommentCubit  addComment',
    () {
      blocTest<CommentCubit, CommentState>(
        'emits [CommentAdding, CommentLoaded] when fetch comments succeeds',
        build: () {
          when(mockAddComment.call(comment))
              .thenAnswer((_) async => responseComment);

          return CommentCubit(mockFetchComments,mockAddComment);
        },
        act: (bloc) async {
          await bloc.addComment(comment);
        },
        expect: () => [
          isA<CommentAdding>(),
          isA<CommentLoaded>(),
        ],
      );

      blocTest<CommentCubit, CommentState>(
        'emits [CommentLoading, CommentError] when add comment fails',
        build: () {
          const errorMessage = 'add comment failed';

          when(mockAddComment.call(comment)).thenAnswer(
            (_) async => Future.error(
              FailureModel(
                state: 400,
                message: errorMessage,
              ),
            ),
          );

          return CommentCubit(mockFetchComments,mockAddComment);
        },
        act: (bloc) async {
          await bloc.addComment(comment);
        },
        expect: () => [
          isA<CommentAdding>(),
          isA<CommentError>().having(
              (state) => state.errorMessage, 'message', 'add comment failed'),
        ],
      );
    },
  );
}
