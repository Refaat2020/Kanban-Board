import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource _projectDataSource;

  ProjectRepositoryImpl(this._projectDataSource);

  @override
  Future<String> getOrCreateDefaultProject() async {
    final existingProjectId =
        locator<PreferenceStorage>().getString(AppKeys.defaultProjectKey);
    if (existingProjectId != null) {
      return existingProjectId;
    }
    final projectId =
        await _projectDataSource.createProject("Kanban Board Project");
    await locator<PreferenceStorage>()
        .setString(AppKeys.defaultProjectKey, projectId);
    return projectId;
    try {
      final existingProjectId =
          locator<PreferenceStorage>().getString(AppKeys.defaultProjectKey);
      if (existingProjectId != null) {
        return existingProjectId;
      }
      final projectId =
          await _projectDataSource.createProject("Kanban Board Project");
      await locator<PreferenceStorage>()
          .setString(AppKeys.defaultProjectKey, projectId);
      return projectId;
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
