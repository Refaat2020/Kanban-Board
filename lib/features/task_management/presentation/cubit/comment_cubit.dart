import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/task_management/data/models/comment_model.dart';
import 'package:kanban_board/features/task_management/domain/usecases/add_comment.dart';
import 'package:kanban_board/file_export.dart';

import '../../domain/entities/comment.dart';
import '../../domain/usecases/fetch_comments.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit(this._commentService,this._addComment) : super(CommentInitial());
  final FetchComments _commentService;
  final AddComment _addComment;

  List<Comment> listOfComments = [];

  Future<void> fetchComments(String taskId) async {
    emit(CommentLoading());
    final result = _commentService.call(taskId);
    await result.execute(
      onFailed: (failed) => emit(CommentError(errorMessage: failed.message)),
      onSuccess: (comments) async {
        if (comments.isEmpty) {
          emit(CommentsEmpty());
        } else {
          listOfComments = comments;
          emit(CommentLoaded());
        }
      },
    );
  }

  Future<void> addComment(CommentModel comment) async {
    emit(CommentAdding());
    final result = _addComment.call(comment);
    await result.execute(
      onFailed: (failed) => emit(CommentError(errorMessage: failed.message)),
      onSuccess: (comment) async {
        listOfComments.add(comment);
        emit(CommentLoaded());
      },
    );
  }
}
