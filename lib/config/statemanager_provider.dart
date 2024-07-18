import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/features/ads/domain/use_cases/index.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource_impl.dart';
import 'package:uniplanet/features/auth/data/repositories/user_repository_impl.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/index.dart';
import 'package:uniplanet/features/category/presentation/blocs/category/category_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/typing/typing_bloc.dart';
import 'package:uniplanet/features/chat/presentation/get_product/get_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/like/like_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/report/presentation/bloc/report_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_history/search_history_bloc.dart';
import 'package:uniplanet/features/product_details/presentation/blocs/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniplanet/features/product_details/presentation/blocs/seller_sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/theme/theme_cubit.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/features/ads/data/repositories/ads_repository_impl.dart';
import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';

import 'package:uniplanet/features/ads/presentation/bloc/ads_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_product/search_product_bloc.dart';
import 'package:uniplanet/main.dart';

final getIt = GetIt.instance;

void setupAds() {
  // Register services
  getIt
    ..registerFactory<AdsRepository>(() => AdsRepositoryImpl())
    // Register use cases
    ..registerFactory<CreateInterstitialAd>(
        () => CreateInterstitialAd(getIt<AdsRepository>()))
    ..registerFactory<ShowInterstitialAd>(
        () => ShowInterstitialAd(getIt<AdsRepository>()))
    ..registerFactory<CreateBannerAd>(
        () => CreateBannerAd(getIt<AdsRepository>()))
    ..registerFactory<CreateNativeAd>(
        () => CreateNativeAd(getIt<AdsRepository>()))
    // Register Blocs
    ..registerLazySingleton(() => AdsBloc(
          createInterstitialAd: getIt<CreateInterstitialAd>(),
          showInterstitialAd: getIt<ShowInterstitialAd>(),
          createBannerAd: getIt<CreateBannerAd>(),
          createNativeAd: getIt<CreateNativeAd>(),
        ));
}

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

void setup() {
  getIt.registerFactory<AccountRepository>(() => AccountRepository());
  getIt.registerFactory<ProductRepository>(() => ProductRepository());
  getIt.registerFactory<ChatRepository>(() => ChatRepository());

  // Data sources
  getIt.registerLazySingleton(() => ProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => CategoryBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => HotProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => SearchProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => AccountBloc(getIt<AccountRepository>()));
  getIt.registerLazySingleton(() => ChatBloc(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => MessageBloc(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => StatusBloc());
  getIt.registerLazySingleton(() => TypingBloc());
  getIt.registerLazySingleton(() => LikeBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => SearchHistoryBloc(getIt<AccountRepository>()));
  getIt.registerLazySingleton(
      () => OnSaleProductBloc(getIt<ProductRepository>()));
  getIt
      .registerLazySingleton(() => SoldProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => SellerSaleProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => SellerSoldProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => GetProductBloc(getIt<ProductRepository>()));
  getIt
      .registerLazySingleton(() => FreeProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => WantedProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => ReportBloc(getIt<AccountRepository>()));
  getIt.registerLazySingleton(() => AdvertiserBloc(getIt<AccountRepository>()));
  getIt.registerLazySingleton(() => AdminBloc(getIt<AccountRepository>()));
  getIt.registerLazySingleton(() => ThemeCubit());
}

class StateManagerProvider extends StatelessWidget {
  const StateManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AdsBloc>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<ProductBloc>()),
        BlocProvider(create: (context) => getIt<CategoryBloc>()),
        BlocProvider(create: (context) => getIt<HotProductBloc>()),
        BlocProvider(create: (context) => getIt<SearchProductBloc>()),
        BlocProvider(create: (context) => getIt<AccountBloc>()),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
        BlocProvider(create: (context) => getIt<MessageBloc>()),
        BlocProvider(create: (context) => getIt<StatusBloc>()),
        BlocProvider(create: (context) => getIt<TypingBloc>()),
        BlocProvider(create: (context) => getIt<LikeBloc>()),
        BlocProvider(create: (context) => getIt<SearchHistoryBloc>()),
        BlocProvider(create: (context) => getIt<OnSaleProductBloc>()),
        BlocProvider(create: (context) => getIt<SoldProductBloc>()),
        BlocProvider(create: (context) => getIt<SellerSaleProductBloc>()),
        BlocProvider(create: (context) => getIt<SellerSoldProductBloc>()),
        BlocProvider(create: (context) => getIt<GetProductBloc>()),
        BlocProvider(create: (context) => getIt<FreeProductBloc>()),
        BlocProvider(create: (context) => getIt<WantedProductBloc>()),
        BlocProvider(create: (context) => getIt<ReportBloc>()),
        BlocProvider(create: (context) => getIt<AdvertiserBloc>()),
        BlocProvider(create: (context) => getIt<AdminBloc>()),
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
      ],
      child: const MyApp(),
    );
  }
}
