import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/account/data/data_sources/account_data_source.dart';
import 'package:uniplanet/features/account/data/repository/account_repository_impl.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/get_account_info_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/update_name_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/update_profile_picture_usecase.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';

final getIt = GetIt.instance;

void accountSetup() {
  // Registering Data Sources
  getIt.registerFactory<AccountDataSource>(() => AccountRemoteDataSourceImpl());

  // Registering AccountRepository
  getIt.registerFactory<AccountRepository>(
      () => AccountRepositoryImpl(getIt<AccountDataSource>()));

  // Registering Account Use Cases
  getIt.registerFactory(() => UpdateNameUseCase(getIt<AccountRepository>()));
  getIt
      .registerFactory(() => GetAccountInfoUseCase(getIt<AccountRepository>()));
  getIt.registerFactory(
      () => UpdateProfilePictureUseCase(getIt<AccountRepository>()));

  // Registering Account Bloc
  getIt.registerLazySingleton(() => AccountBloc(
        getAccountInfoUseCase: getIt<GetAccountInfoUseCase>(),
        updateNameUseCase: getIt<UpdateNameUseCase>(),
        updateProfilePictureUseCase: getIt<UpdateProfilePictureUseCase>(),
      ));
}
