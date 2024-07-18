// lib/features/auth/domain/usecases/sign_up_user.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/entities/user_type.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class SignUpUser implements UseCase<String, SignUpParams> {
  final AuthRepository repository;

  SignUpUser(this.repository);

  @override
  Future<Either<Failure, String>> call(SignUpParams params) async {
    return await repository.signUpUser(
      email: params.email,
      password: params.password,
      name: params.name,
      school: params.school,
      userType: params.userType,
      phoneNumber: params.phoneNumber,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String name;
  final String school;
  final UserType userType;
  final String phoneNumber;

  SignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.school,
    required this.userType,
    required this.phoneNumber,
  });
}
