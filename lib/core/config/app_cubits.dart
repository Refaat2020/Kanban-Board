import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/core/theme/theme_cubit.dart';
import 'package:kanban_board/core/theme/theme_repository_impl.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/features/task_management/domain/service/task_management_service.dart';
import 'package:provider/single_child_widget.dart';

class AppCubits {
  static List<SingleChildWidget> appCubit() => [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(locator<ThemeRepository>()),
        ),
        BlocProvider<TaskManagementCubit>(
          create: (context) =>
              TaskManagementCubit(locator<TaskManagementService>()),
        ),
      ];
}
