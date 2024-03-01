import 'package:uniplanet_mobile/models/User.dart';

abstract class UserRepositoryTest {
  abstract Future<User> signUpUser;
}
