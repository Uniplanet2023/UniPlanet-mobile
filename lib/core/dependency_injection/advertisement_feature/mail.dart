// lib/injection_container.dart
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/advertiser/data/data_sources/mail_remote_data_source.dart';
import 'package:uniplanet/features/advertiser/data/repository/mail_repository_impl.dart';
import 'package:uniplanet/features/advertiser/domain/repository/mail_repository.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/send_ad_complain_mail.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/mail/mail_bloc.dart';

void setupMail() {
  // Registering MailRemoteDataSource
  getIt.registerFactory<MailRemoteDataSource>(() => MailRemoteDataSourceImpl());

  // Registering MailRepository
  getIt.registerFactory<MailRepository>(
      () => MailRepositoryImpl(getIt<MailRemoteDataSource>()));

  // Registering SendMailUseCase
  getIt.registerFactory(
      () => SendAdComplainMailUseCase(getIt<MailRepository>()));

  // Registering BLoC
  getIt.registerLazySingleton(
      () => MailBloc(getIt<SendAdComplainMailUseCase>()));
}
