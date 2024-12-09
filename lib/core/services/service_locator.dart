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
import 'package:kanban_board/features/kanban_board/domain/service/project_service.dart';
import 'package:kanban_board/features/kanban_board/domain/service/task_service.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source.dart';
import 'package:kanban_board/features/task_management/data/data_source/comment_data_source_impl.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source.dart';
import 'package:kanban_board/features/task_management/data/data_source/task_management_data_source_impl.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository.dart';
import 'package:kanban_board/features/task_management/data/repository/comment_repository_impl.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository.dart';
import 'package:kanban_board/features/task_management/data/repository/task_management_repository_impl.dart';
import 'package:kanban_board/features/task_management/domain/service/comment_service.dart';
import 'package:kanban_board/features/task_management/domain/service/task_management_service.dart';

import 'dio_client_impl.dart';

final locator = GetIt.instance;

///how to take object from class in service locator
/// Repo repo = locator<Repo>();
void setupLocator() {
  // App Services
  locator.registerLazySingleton<Dio>(
      () => Dio()..interceptors.add(DioNetworkLogger()));

  locator.registerLazySingleton<DioConfigOptions>(() => DioConfigOptions());

  locator.registerLazySingleton<DioClient>(
    () => DioClientImpl(
      dio: locator<Dio>(),
      dioConfigOptions: locator<DioConfigOptions>(),
    ),
  );

  locator.registerLazySingleton(() => PreferenceStorage());

  locator.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl());

  //  Feature Data source

  locator.registerLazySingleton<ProjectDataSource>(
    () => ProjectDataSourceImpl(locator<DioClient>()),
  );

  locator.registerLazySingleton<TaskDataSource>(
    () => TasksDataSourceImpl(locator<DioClient>()),
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
    () => TaskRepositoryImpl(locator<TaskDataSource>()),
  );

  locator.registerLazySingleton<TaskManagementRepository>(
    () => TaskManagementRepositoryImpl(locator<TaskManagementDataSource>()),
  );

  locator.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(locator<CommentDataSource>()),
  );

  // Feature Services
  locator.registerLazySingleton(
    () => ProjectService(locator<ProjectRepository>()),
  );

  locator.registerLazySingleton(
    () => TaskService(locator<TaskRepository>()),
  );

  locator.registerLazySingleton(
    () => TaskManagementService(locator<TaskManagementRepository>()),
  );
  locator.registerLazySingleton(
    () => CommentService(locator<CommentRepository>()),
  );
}
