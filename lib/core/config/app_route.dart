import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/kanban_cubit.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/project_cubit.dart';
import 'package:kanban_board/features/kanban_board/domain/service/project_service.dart';
import 'package:kanban_board/features/kanban_board/domain/service/task_service.dart';
import 'package:kanban_board/features/kanban_board/views/board/board_screen.dart';
import 'package:kanban_board/features/kanban_board/views/splash/splash.dart';
import 'package:kanban_board/features/task_management/domain/cubit/comment_cubit.dart';
import 'package:kanban_board/features/task_management/domain/service/comment_service.dart';
import 'package:kanban_board/features/task_management/views/completed_task/history_screen.dart';
import 'package:kanban_board/features/task_management/views/create_task/create_task_screen.dart';
import 'package:kanban_board/features/task_management/views/view_task/view_task_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final route = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    observers: [
      // DatadogNavigationObserver(datadogSdk: DatadogSdk.instance),
    ],
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => ProjectCubit(locator<ProjectService>()),
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: BoardScreen.routePath,
        name: BoardScreen.routePath,
        builder: (context, state) => BlocProvider(
          create: (context) => KanbanCubit(locator<TaskService>()),
          child: BoardScreen(),
        ),
        routes: [
          GoRoute(
            path: CreateTaskScreen.routePath,
            name: CreateTaskScreen.routeName,
            builder: (context, state) => CreateTaskScreen(),
          ),
          GoRoute(
            path: ViewTaskScreen.routePath,
            name: ViewTaskScreen.routeName,
            builder: (context, state) {
              final task = state.extra as Task;
              return BlocProvider<CommentCubit>(
                create: (context) => CommentCubit(locator<CommentService>()),
                child: ViewTaskScreen(
                  task: task,
                ),
              );
            },
          ),
          GoRoute(
            path: HistoryScreen.routePath,
            name: HistoryScreen.routeName,
            builder: (context, state) {
              final tasks = state.extra as List<Task>;
              return HistoryScreen(tasks);
            },
          ),
        ],
      ),
    ],
  );
}
