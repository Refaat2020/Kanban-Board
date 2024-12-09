import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source.dart';

class CommentDataSourceImpl implements CommentDataSource {
  final DioClient _dioClient;

  CommentDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> addComment(
      Map<String, dynamic> commentBody) async {
    try {
      final response =
          await _dioClient.postRequest(commentBody, AppUrl.postAddComment);
      return response;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<List> fetchComments(String taskId) async {
    try {
      final response = await _dioClient
          .getRequest(AppUrl.postAddComment, prams: {'task_id': taskId});
      return response;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
