import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/account/data/data_sources/admin_data_source.dart';
import 'package:uniplanet/features/account/data/repository/admin_repository_impl.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/block_post_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/get_advertiser_list_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/get_more_advertiser_list_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/increase_credit_usecase.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';

final getIt = GetIt.instance;

void adminInjectionSetup() {
  // Registering Data Sources
  getIt.registerFactory<AdminDataSource>(() => AdminDataSourceImpl());

  // Registering AdminRepository
  getIt.registerFactory<AdminRepository>(
      () => AdminRepositoryImpl(getIt<AdminDataSource>()));

  // Registering Admin Use Cases
  getIt.registerFactory(() => BlockPostUsecase(getIt<AdminRepository>()));
  getIt.registerFactory(
      () => GetAdvertiserListUsecase(getIt<AdminRepository>()));
  getIt.registerFactory(
      () => GetMoreAdvertiserListUsecase(getIt<AdminRepository>()));
  getIt.registerFactory(() => IncreaseCreditUsecase(getIt<AdminRepository>()));

  // Registering Admin Bloc
  getIt.registerLazySingleton(
    () => AdminBloc(
      blockPostUsecase: getIt<BlockPostUsecase>(),
      getAdvertiserListUsecase: getIt<GetAdvertiserListUsecase>(),
      getMoreAdvertiserListUsecase: getIt<GetMoreAdvertiserListUsecase>(),
      increaseCreditUsecase: getIt<IncreaseCreditUsecase>(),
    ),
  );
}
