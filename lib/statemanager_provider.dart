import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uniplanet/bloc/admin/admin_bloc.dart';
import 'package:uniplanet/bloc/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/bloc/free_product/free_product_bloc.dart';
import 'package:uniplanet/bloc/get_product/get_product_bloc.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/features/report/presentation/bloc/report_bloc.dart';
import 'package:uniplanet/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_history/search_history_bloc.dart';
import 'package:uniplanet/bloc/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniplanet/bloc/seller_sold_product/sold_product_bloc.dart';
import 'package:uniplanet/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/bloc/theme/theme_cubit.dart';
import 'package:uniplanet/features/home/bloc/wanted_product_bloc.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/features/ads/data/repositories/ads_repository_impl.dart';
import 'package:uniplanet/features/ads/domain/repositories/ads_repository.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_banner_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_interstitial_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/create_native_ad.dart';
import 'package:uniplanet/features/ads/domain/use_cases/show_interstitial_ad.dart';
import 'package:uniplanet/features/ads/presentation/bloc/ads_bloc.dart';
import 'package:uniplanet/main.dart';

final getIt = GetIt.instance;

void setupAds() {
  // Register services
  getIt.registerLazySingleton<AdsRepository>(() => AdsRepositoryImpl());

  // Register use cases
  getIt.registerLazySingleton<CreateInterstitialAd>(
      () => CreateInterstitialAd(getIt<AdsRepository>()));
  getIt.registerLazySingleton<ShowInterstitialAd>(
      () => ShowInterstitialAd(getIt<AdsRepository>()));
  getIt.registerLazySingleton<CreateBannerAd>(
      () => CreateBannerAd(getIt<AdsRepository>()));
  getIt.registerLazySingleton<CreateNativeAd>(
      () => CreateNativeAd(getIt<AdsRepository>()));
  // Register Blocs
  getIt.registerFactory(() => AdsBloc(
        createInterstitialAd: getIt<CreateInterstitialAd>(),
        showInterstitialAd: getIt<ShowInterstitialAd>(),
        createBannerAd: getIt<CreateBannerAd>(),
        createNativeAd: getIt<CreateNativeAd>(),
      ));
}

void setup() {
  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(DioHelper.instance));
  getIt.registerLazySingleton<AccountRepository>(
      () => AccountRepository(DioHelper.instance));
  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepository(DioHelper.instance));
  getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepository(DioHelper.instance));

  // Register Blocs
  getIt.registerFactory(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => ProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => CategoryBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => HotProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => SearchProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => AccountBloc(getIt<AccountRepository>()));
  getIt.registerFactory(() => ChatBloc(getIt<ChatRepository>()));
  getIt.registerFactory(() => MessageBloc(getIt<ChatRepository>()));
  getIt.registerFactory(() => StatusBloc());
  getIt.registerFactory(() => TypingBloc());
  getIt.registerFactory(() => LikeBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => SearchHistoryBloc(getIt<AccountRepository>()));
  getIt.registerFactory(() => OnSaleProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => SoldProductBloc(getIt<ProductRepository>()));
  getIt
      .registerFactory(() => SellerSaleProductBloc(getIt<ProductRepository>()));
  getIt
      .registerFactory(() => SellerSoldProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => GetProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => FreeProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => WantedProductBloc(getIt<ProductRepository>()));
  getIt.registerFactory(() => ReportBloc(getIt<AccountRepository>()));
  getIt.registerFactory(() => AdvertiserBloc(getIt<AccountRepository>()));
  getIt.registerFactory(() => AdminBloc(getIt<AccountRepository>()));
  getIt.registerFactory(() => ThemeCubit());
}

class StateManagerProvider extends StatelessWidget {
  const StateManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => getIt<AuthRepository>()),
        RepositoryProvider(create: (context) => getIt<AccountRepository>()),
        RepositoryProvider(create: (context) => getIt<ProductRepository>()),
        RepositoryProvider(create: (context) => getIt<ChatRepository>()),
        RepositoryProvider(create: (context) => getIt<AdsRepository>()),
      ],
      child: MultiBlocProvider(
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
      ),
    );
  }
}
