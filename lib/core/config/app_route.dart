
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/domain/usecases/fetch_tasks.dart';
import 'package:kanban_board/features/task_management/domain/usecases/add_comment.dart';
import 'package:kanban_board/features/task_management/domain/usecases/fetch_comments.dart';

import '../../features/kanban_board/domain/entities/task.dart';
import '../../features/kanban_board/domain/usecases/get_or_create_default_project.dart';
import '../../features/kanban_board/domain/usecases/initial_sync_tasks.dart';
import '../../features/kanban_board/presentation/cubit/kanban_cubit.dart';
import '../../features/kanban_board/presentation/cubit/project_cubit.dart';
import '../../features/kanban_board/presentation/views/board/board_screen.dart';
import '../../features/kanban_board/presentation/views/splash/splash.dart';
import '../../features/task_management/presentation/cubit/comment_cubit.dart';
import '../../features/task_management/presentation/views/completed_task/history_screen.dart';
import '../../features/task_management/presentation/views/create_task/create_task_screen.dart';
import '../../features/task_management/presentation/views/view_task/view_task_screen.dart';
import '../../file_export.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final route = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => ProjectCubit(locator<GetOrCreateDefaultProject>()),
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: BoardScreen.routePath,
        name: BoardScreen.routePath,
        builder: (context, state) => BlocProvider(
          create: (context) => KanbanCubit(locator<FetchTasks>(),locator<InitialSyncTasks>()),
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
                create: (context) => CommentCubit(locator<FetchComments>(),locator<AddComment>()),
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
