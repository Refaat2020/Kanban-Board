import '../../domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> fetchComments(String taskId);
  Future<Comment> addComment(Comment comment);
}
