import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/extensions/task_excuter.dart';
import 'package:kanban_board/features/kanban_board/domain/service/project_service.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._projectService) : super(ProjectInitial());

  final ProjectService _projectService;

  Future<void> getOrCreateProject() async {
    emit(ProjectLoading());
    var result = _projectService.getOrCreateDefaultProject();
    await result.execute(
      onFailed: (failed) => emit(ProjectError(errorMessage: failed.message)),
      onSuccess: (value) async {
        emit(ProjectLoaded());
      },
    );
  }
}
