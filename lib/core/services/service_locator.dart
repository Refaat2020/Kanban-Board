import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban_board/core/config/dio_options.dart';
import 'package:kanban_board/core/extensions/dio_network_logger.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/theme/theme_repository.dart';
import 'package:kanban_board/core/theme/theme_repository_impl.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/project_data_source_impl.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source.dart';
import 'package:kanban_board/features/kanban_board/data/data_source/tasks_data_source_impl.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository.dart';
import 'package:kanban_board/features/kanban_board/data/repository/project_repository_impl.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository.dart';
import 'package:kanban_board/features/kanban_board/data/repository/task_repository_impl.dart';
import 'package:kanban_board/features/kanban_board/domain/usecases/fetch_tasks.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source_impl.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source_impl.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository_impl.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository_impl.dart';
import 'package:kanban_board/features/task_management/domain/usecases/create_task.dart';
import 'package:kanban_board/features/task_management/domain/usecases/update_task.dart';

import '../../features/kanban_board/data/data_source/task_local_data_source.dart';
import '../../features/kanban_board/data/data_source/task_local_data_source_impl.dart';
import '../../features/kanban_board/domain/usecases/get_or_create_default_project.dart';
import '../../features/kanban_board/domain/usecases/initial_sync_tasks.dart';
import '../../features/task_management/domain/usecases/add_comment.dart';
import '../../features/task_management/domain/usecases/fetch_comments.dart';
import '../bootstrap/app_bootstrap.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../sync/data/data_source/sync_queue_data_source.dart';
import '../sync/data/data_source/sync_queue_data_source_impl.dart';
import '../sync/engine/background_sync_engine.dart';
import 'dio_client_impl.dart';

final locator = GetIt.instance;

///how to take object from class in usecases locator
/// Repo repo = locator<Repo>();
void setupLocator() {
  // App Services
  locator.registerLazySingleton<Dio>(
    () => Dio()..interceptors.add(DioNetworkLogger()),
  );

  locator.registerLazySingleton<DioConfigOptions>(() => DioConfigOptions());
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );
  locator.registerLazySingleton<DioClient>(
    () => DioClientImpl(
      dio: locator<Dio>(),
      dioConfigOptions: locator<DioConfigOptions>(),
    ),
  );

  locator.registerLazySingleton(() => PreferenceStorage());

  locator.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());
  locator.registerLazySingleton<SyncQueueDataSource>(
    () => SyncQueueDataSourceImpl(),
  );

  //  Feature Data source

  locator.registerLazySingleton<ProjectDataSource>(
    () => ProjectDataSourceImpl(locator<DioClient>()),
  );

  locator.registerLazySingleton<TaskDataSource>(
    () => TasksDataSourceImpl(locator<DioClient>()),
  );
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  locator.registerLazySingleton<TaskManagementDataSource>(
    () => TaskManagementDataSourceImpl(locator<DioClient>()),
  );

  locator.registerLazySingleton<CommentDataSource>(
    () => CommentDataSourceImpl(locator<DioClient>()),
  );

  // Feature Repository
  locator.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(locator<ProjectDataSource>()),
  );

  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      locator<TaskLocalDataSource>(),
      locator<TaskDataSource>(),
    ),
  );

  locator.registerLazySingleton<TaskManagementRepository>(
    () => TaskManagementRepositoryImpl(
      locator<TaskLocalDataSource>(),
      locator<SyncQueueDataSource>(),
    ),
  );

  locator.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(locator<CommentDataSource>()),
  );

  // Feature UseCase
  locator.registerLazySingleton(
    () => GetOrCreateDefaultProject(locator<ProjectRepository>()),
  );

  locator.registerLazySingleton(() => FetchTasks(locator<TaskRepository>()));

  locator.registerLazySingleton(
    () => CreateTask(locator<TaskManagementRepository>()),
  );

  locator.registerLazySingleton(
    () => UpdateTask(locator<TaskManagementRepository>()),
  );
  locator.registerLazySingleton(() => AddComment(locator<CommentRepository>()));
  locator.registerLazySingleton(
    () => FetchComments(locator<CommentRepository>()),
  );
  locator.registerLazySingleton(
    () => InitialSyncTasks(locator<TaskRepository>()),
  );

  locator.registerLazySingleton(
    () => BackgroundSyncEngine(
      locator<SyncQueueDataSource>(),
      locator<TaskManagementDataSource>(),
      locator<TaskLocalDataSource>(),
      locator<NetworkInfo>(),
    ),
  );

  locator.registerLazySingleton<AppBootstrap>(
    () => AppBootstrap(locator<BackgroundSyncEngine>(), locator<NetworkInfo>()),
  );
}
