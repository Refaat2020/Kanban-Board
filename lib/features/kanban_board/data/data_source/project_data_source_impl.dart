import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_urls.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source.dart';

class ProjectDataSourceImpl implements ProjectDataSource {
  final DioClient _dioClient;

  ProjectDataSourceImpl(this._dioClient);

  @override
  Future<String> createProject(String name) async {
    try {
      final response = await _dioClient
          .postRequest({"name": name}, AppUrl.postCreateProject);

      return response['id'];
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
