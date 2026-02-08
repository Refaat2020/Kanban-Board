import '../../data/repository/comment_repository.dart';
import '../entities/comment.dart';

class AddComment {
  final CommentRepository repository;

  AddComment(this.repository);

  Future<Comment> call(Comment comment) {
    return repository.addComment(comment);
  }
}