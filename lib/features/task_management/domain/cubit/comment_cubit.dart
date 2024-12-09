import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/task_management/data/models/comment.dart';
import 'package:kanban_board/features/task_management/domain/service/comment_service.dart';
import 'package:kanban_board/file_export.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit(this._commentService) : super(CommentInitial());
  final CommentService _commentService;

  List<Comment> listOfComments = [];

  Future<void> fetchComments(String taskId) async {
    emit(CommentLoading());
    final result = _commentService.fetchComments(taskId);
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

  Future<void> addComment(Comment comment) async {
    emit(CommentAdding());
    final result = _commentService.addComment(comment);
    await result.execute(
      onFailed: (failed) => emit(CommentError(errorMessage: failed.message)),
      onSuccess: (comment) async {
        listOfComments.add(comment);
        emit(CommentLoaded());
      },
    );
  }
}
