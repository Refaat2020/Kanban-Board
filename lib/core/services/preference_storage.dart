import 'package:shared_preferences/shared_preferences.dart';

import '../../file_export.dart';

class PreferenceStorage {
  late SharedPreferences _sharedPreferencesStorage;

  Future<void> init() async {
    _sharedPreferencesStorage = await SharedPreferences.getInstance();
  }

  Future<bool?> setString(String key, String value) async {
    try {
      return await _sharedPreferencesStorage.setString(key, value);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool?> setBool(String key, bool value) async {
    try {
      return await _sharedPreferencesStorage.setBool(key, value);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  String? getString(
    String key,
  ) {
    try {
      return _sharedPreferencesStorage.getString(
        key,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  bool? getBool(
    String key,
  ) {
    try {
      return _sharedPreferencesStorage.getBool(
        key,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
