import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/task_management/data/models/comment.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository.dart';

class CommentService {
  final CommentRepository _commentRepository;

  CommentService(this._commentRepository);

  Future<List<Comment>> fetchComments(String taskId) async {
    try {
      return await _commentRepository.fetchComments(taskId);
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  Future<Comment> addComment(
    Comment comment,
  ) async {
    try {
      return await _commentRepository.addComment(
        comment,
      );
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
