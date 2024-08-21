import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/category/category_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/typing/typing_bloc.dart';
import 'package:uniplanet/features/chat/presentation/get_product/get_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
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
import 'package:uniplanet/features/search/presentation/blocs/search_product/search_product_bloc.dart';

final getIt = GetIt.instance;
//TODO: Need to refactor this code
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
