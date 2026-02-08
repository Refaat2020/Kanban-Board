import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/extensions/task_excuter.dart';

import '../../domain/usecases/get_or_create_default_project.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._projectUseCase) : super(ProjectInitial());

  final GetOrCreateDefaultProject _projectUseCase;

  Future<void> getOrCreateProject() async {
    emit(ProjectLoading());
    var result = _projectUseCase.call();
    await result.execute(
      onFailed: (failed) => emit(ProjectError(errorMessage: failed.message)),
      onSuccess: (value) async {
        emit(ProjectLoaded());
      },
    );
  }
}
