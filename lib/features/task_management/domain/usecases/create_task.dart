import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';

import '../../../kanban_board/domain/entities/task.dart';

class CreateTask {
  final TaskManagementRepository _taskManagementRepository;

  CreateTask(this._taskManagementRepository);

  Future<Task> call(Task task)  {
    return  _taskManagementRepository.createTask(task);
  }
}
