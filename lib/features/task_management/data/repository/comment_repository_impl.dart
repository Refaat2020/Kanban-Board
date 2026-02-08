import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source.dart';
import 'package:kanban_board/features/task_management/data/models/comment_model.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository.dart';

import '../../domain/entities/comment.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource _commentDataSource;

  CommentRepositoryImpl(this._commentDataSource);

  @override
  Future<Comment> addComment(comment) async {
    try {
      final model = CommentModel.fromEntity(comment);

      final response = await _commentDataSource.addComment(
        model.toJson(),
      );
      return CommentModel.fromJson(response).toEntity();
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<List<Comment>> fetchComments(String taskId) async {
    try {
      final response = await _commentDataSource.fetchComments(
        taskId,
      );
      List<Comment> comments =
          List<Comment>.from((response).map((x) => CommentModel.fromJson(x).toEntity()));

      return comments;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
