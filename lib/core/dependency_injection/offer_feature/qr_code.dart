import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/offer/data/data_sources/qr_remote_data_source.dart';
import 'package:uniplanet/features/offer/data/repositories/qr_repository_impl.dart';
import 'package:uniplanet/features/offer/domain/repositories/qr_repository.dart';
import 'package:uniplanet/features/offer/domain/usecases/validate_qr_token_usecase.dart';
import 'package:uniplanet/features/offer/presentation/blocs/qr_code_scan/qr_code_scan_bloc.dart';

Future<void> initQrScanner() async {
  // Registering data sources
  getIt.registerFactory<QrRemoteDataSource>(() => QrRemoteDataSourceImpl());

  // Registering repositories
  getIt.registerFactory<QrRepository>(
    () => QrRepositoryImpl(remoteDataSource: getIt<QrRemoteDataSource>()),
  );

  // Registering use cases
  getIt.registerFactory(() => ValidateQRTokenUseCase(getIt<QrRepository>()));

  // Registering BLoC
  getIt.registerLazySingleton(() =>
      QrCodeScanBloc(validateQRTokenUseCase: getIt<ValidateQRTokenUseCase>()));
}
