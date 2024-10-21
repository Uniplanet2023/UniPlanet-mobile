import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource_impl.dart';
import 'package:uniplanet/features/auth/data/repositories/user_repository_impl.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/index.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';

void setupAuth() {
  getIt
    // Data sources
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl())
    // Repositories
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()))
    // Use cases
    ..registerFactory(() => SignUpUser(getIt<AuthRepository>()))
    ..registerFactory(() => SignInUser(getIt<AuthRepository>()))
    ..registerFactory(() => TokenValidation(getIt<AuthRepository>()))
    ..registerFactory(() => SignOutUser(getIt<AuthRepository>()))
    ..registerFactory(() => UpdatePassword(getIt<AuthRepository>()))
    ..registerFactory(() => ResetPassword(getIt<AuthRepository>()))
    ..registerFactory(() => OtpRequest(getIt<AuthRepository>()))
    ..registerFactory(() => OtpValidation(getIt<AuthRepository>()))
    ..registerFactory(() => DeleteUser(getIt<AuthRepository>()))
    // Register Blocs
    ..registerLazySingleton(() => AuthBloc(
          signIn: getIt<SignInUser>(),
          signUp: getIt<SignUpUser>(),
          signOut: getIt<SignOutUser>(),
          resetPassword: getIt<ResetPassword>(),
          deleteUser: getIt<DeleteUser>(),
          otpValidation: getIt<OtpValidation>(),
          otpRequest: getIt<OtpRequest>(),
          updatePassword: getIt<UpdatePassword>(),
          tokenValidation: getIt<TokenValidation>(),
        ));
}
