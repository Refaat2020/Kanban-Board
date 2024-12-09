abstract class ThemeRepository {
  Future<void> saveTheme(bool isDarkMode);
  Future<bool> loadTheme();
}
