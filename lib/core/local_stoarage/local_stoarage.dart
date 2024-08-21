import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';

class LocalStorage {
  // Private constructor for Singleton pattern
  LocalStorage._privateConstructor();

  // Single instance of LocalStorage
  static final LocalStorage _instance = LocalStorage._privateConstructor();

  // Factory method to return the same instance
  factory LocalStorage() {
    return _instance;
  }

  User getUserData() {
    try {
      final userDataString =
          SharedPreferencesHelper.instance.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception('User data not found');
      }
      return User.fromJson(userDataString);
    } catch (e) {
      throw Exception('Failed to retrieve user data: $e');
    }
  }
}
