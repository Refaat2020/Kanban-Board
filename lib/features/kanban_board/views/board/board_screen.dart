import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kanban_board/common/widgets/empty_state_widget.dart';
import 'package:kanban_board/common/widgets/error_state.dart';
import 'package:kanban_board/common/widgets/loading_state.dart';
import 'package:kanban_board/core/constants/app_colors.dart';
import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/extensions/theme_extensions.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/core/theme/theme_cubit.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/kanban_cubit.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/filtered_tasks_view.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/features/task_management/views/completed_task/history_screen.dart';
import 'package:kanban_board/features/task_management/views/create_task/create_task_screen.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  static const routePath = "/BoardScreen";
  static const routeName = "/BoardScreen";

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late final String _projectId;
  late final KanbanCubit kanbanCubit;

  @override
  void initState() {
    super.initState();
    _projectId =
        locator<PreferenceStorage>().getString(AppKeys.defaultProjectKey) ?? "";
    kanbanCubit = context.read<KanbanCubit>();
    kanbanCubit.fetchTasks(_projectId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskManagementCubit, TaskManagementState>(
      listener: (context, state) {
        if (state is TaskManagementUpdatedDone) {
          kanbanCubit.fetchTasks(_projectId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task updated Successfully')),
          );
        } else if (state is TaskManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              GoRouter.of(context).pushNamed(CreateTaskScreen.routeName),
          backgroundColor: AppColors.purple3,
          child: Text(
            "ADD",
            style: context.textTheme.bodyLarge,
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              final isDarkMode = context.isDarkModelEnabled;
              context.read<ThemeCubit>().switchTheme(!isDarkMode);
            },
            icon: Icon(
              context.isDarkModelEnabled ? Icons.dark_mode : Icons.sunny,
            ),
          ),
          title: Text(
            "Kanban Board",
            style: context.textTheme.titleLarge,
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  List<Task> listOfCompletedTasks = [];
                  if (context.read<KanbanCubit>().columnDataList.isNotEmpty &&
                      context
                          .read<KanbanCubit>()
                          .columnDataList[2]
                          .tasks
                          .isNotEmpty) {
                    listOfCompletedTasks =
                        context.read<KanbanCubit>().columnDataList[2].tasks;
                  }
                  GoRouter.of(context).pushNamed(HistoryScreen.routeName,
                      extra: listOfCompletedTasks);
                },
                child: Text(
                  'Completed Tasks',
                ))
          ],
        ),
        body: BlocConsumer<KanbanCubit, KanbanState>(
          listener: (context, state) {
            if (state is KanbanTasksLoaded) {
              kanbanCubit.filterTasks(state.tasks);
            }
          },
          builder: (context, state) {
            if (state is KanbanLoading) {
              return const LoadingState();
            } else if (state is KanbanError) {
              return ErrorState(state.errorMessage ?? '');
            } else if (state is KanbanEmptyTasks) {
              return Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 4),
                child: EmptyStateWidget(
                    message: Text(
                  "No Tasks Found",
                  style: context.textTheme.titleLarge,
                )),
              );
            } else if (state is KanbanFilteredTasks) {
              return FilteredTasksView(
                filteredTasks: state.filteredTasks,
              );
            }
            return ErrorState('Something went wrong');
          },
        ),
      ),
    );
  }
}
