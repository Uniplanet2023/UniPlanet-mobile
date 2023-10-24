import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    isOnline: false,
    phoneNumber: '',
    address: '',
    type: '',
    token: '',
    like: [],
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      isOnline: false,
      phoneNumber: '',
      address: '',
      type: '',
      token: '',
      like: [],
    );
    notifyListeners(); // Notifies any listening widgets to rebuild.
  }
}
