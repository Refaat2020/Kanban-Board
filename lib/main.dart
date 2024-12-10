import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kanban_board/core/config/app_cubits.dart';
import 'package:kanban_board/core/config/app_route.dart';
import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/theme/theme_cubit.dart';

import 'core/config/observer.dart';
import 'core/services/service_locator.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Bloc.observer = AppBlocObserver();
  await locator<PreferenceStorage>().init();
  runApp(
    MultiBlocProvider(
      providers: AppCubits.appCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        return MaterialApp.router(
          routerConfig: AppRouter.route,
          theme: theme,
          title: AppStrings.kanbanBoard,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
