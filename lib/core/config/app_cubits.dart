import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/core/theme/theme_cubit.dart';
import 'package:kanban_board/core/theme/theme_repository_impl.dart';
import 'package:kanban_board/features/task_management/domain/usecases/create_task.dart';
import 'package:kanban_board/features/task_management/domain/usecases/update_task.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/task_management/presentation/cubit/task_management_cubit.dart';

class AppCubits {
  static List<SingleChildWidget> appCubit() => [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(locator<ThemeRepository>()),
        ),
        BlocProvider<TaskManagementCubit>(
          create: (context) =>
              TaskManagementCubit(locator<CreateTask>(),locator<UpdateTask>()),
        ),
      ];
}
