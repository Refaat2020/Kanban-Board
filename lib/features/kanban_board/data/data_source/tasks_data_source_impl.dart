import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source.dart';

class TasksDataSourceImpl implements TaskDataSource {
  final DioClient _dioClient;

  TasksDataSourceImpl(this._dioClient);

  @override
  Future<List> fetchTasks(String projectId) async {
    try {
      final response = await _dioClient
          .getRequest(AppUrl.getTasks, prams: {'project_id': projectId});
      return response;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
