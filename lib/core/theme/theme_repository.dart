import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/core/theme/theme_repository_impl.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  @override
  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = locator<PreferenceStorage>();
    await prefs.setBool(AppKeys.themeKey, isDarkMode);
  }

  @override
  Future<bool> loadTheme() async {
    final prefs = locator<PreferenceStorage>();
    return prefs.getBool(AppKeys.themeKey) ?? true; // Default to light mode
  }
}
