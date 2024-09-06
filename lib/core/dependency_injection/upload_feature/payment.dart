import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/upload/data/data_sources/stripe_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/repositories/payment_repository_impl.dart';
import 'package:uniplanet/features/upload/domain/repositories/payment_repository.dart';
import 'package:uniplanet/features/upload/domain/usecases/create_payment_intent.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';

final getIt = GetIt.instance;

void setupPayment() {
  getIt
    // Data sources
    ..registerFactory<StripeRemoteDataSource>(
        () => StripeRemoteDataSourceImpl())
    // Repositories
    ..registerFactory<PaymentRepository>(() => PaymentRepositoryImpl(
          remoteDataSource: getIt<StripeRemoteDataSource>(),
        ))
    // Use cases
    ..registerFactory(() => CreatePaymentIntent(getIt<PaymentRepository>()))
    // Register Blocs
    ..registerLazySingleton(() => PaymentBloc(
          createPaymentIntent: getIt<CreatePaymentIntent>(),
        ));
}
