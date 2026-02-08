import 'package:kanban_board/features/kanban_board/data/repository/project_repository.dart';


class GetOrCreateDefaultProject {
  final ProjectRepository repository;

  GetOrCreateDefaultProject(this.repository);

  Future<String> call() {
    return repository.getOrCreateDefaultProject();
  }
}
