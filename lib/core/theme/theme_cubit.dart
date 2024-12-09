import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/core/theme/theme_repository_impl.dart';

import 'app_themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final ThemeRepository repository;

  ThemeCubit(this.repository) : super(AppThemes.lightTheme) {
    _loadTheme();
  }

  void switchTheme(bool isDarkMode) {
    final newTheme = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    emit(newTheme);
    repository.saveTheme(isDarkMode);
  }

  void _loadTheme() async {
    final isDarkMode = await repository.loadTheme();
    emit(isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme);
  }
}
