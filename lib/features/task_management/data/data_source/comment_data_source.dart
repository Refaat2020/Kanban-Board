abstract class CommentDataSource {
  Future<List> fetchComments(String taskId);
  Future<Map<String, dynamic>> addComment(
    Map<String, dynamic> commentBody,
  );
}
