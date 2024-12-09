import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';

class TaskManagementDataSourceImpl implements TaskManagementDataSource {
  final DioClient _dioClient;

  TaskManagementDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> createTask(
      Map<String, dynamic> taskContent) async {
    try {
      final response =
          await _dioClient.postRequest(taskContent, AppUrl.postCreateTask);
      return response;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> updateTask(
      Map<String, dynamic> updatedTaskContent, String taskId) async {
    try {
      final response = await _dioClient.postRequest(
          updatedTaskContent, AppUrl.postUpdateTask(taskId));
      return response;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
