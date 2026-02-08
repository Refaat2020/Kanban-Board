import '../../data/repository/comment_repository.dart';
import '../entities/comment.dart';

class FetchComments {
  final CommentRepository repository;

  FetchComments(this.repository);

  Future<List<Comment>> call(String taskId) {
    return repository.fetchComments(taskId);
  }
}