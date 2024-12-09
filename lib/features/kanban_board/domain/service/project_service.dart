import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository.dart';

class ProjectService {
  final ProjectRepository _projectRepository;

  ProjectService(this._projectRepository);

  Future<String> getOrCreateDefaultProject() async {
    try {
      return await _projectRepository.getOrCreateDefaultProject();
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
