import 'package:kanban_board/features/task_management/data/models/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> fetchComments(String taskId);
  Future<Comment> addComment(Comment comment);
}
