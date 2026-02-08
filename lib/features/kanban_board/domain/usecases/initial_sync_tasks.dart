import '../../data/repository/task_repository.dart';

class InitialSyncTasks {
  final TaskRepository _repository;


  InitialSyncTasks(this._repository,);

  Future<void> call(String projectId) async {
    return _repository.initialSync(projectId);
  }
}