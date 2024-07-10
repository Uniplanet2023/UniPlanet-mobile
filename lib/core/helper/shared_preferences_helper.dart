import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  SharedPreferences? _preferences;

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save a string value
  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Retrieve a string value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Retrieve a boolean value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save an integer value
  Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Retrieve an integer value
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save a double value
  Future<void> saveDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  // Retrieve a double value
  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  // Save a list of strings
  Future<void> saveStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  // Retrieve a list of strings
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  // Remove a value
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all values
  Future<void> clear() async {
    await _preferences?.clear();
  }
}
