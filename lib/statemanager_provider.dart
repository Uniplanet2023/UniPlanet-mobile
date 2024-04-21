import 'package:flutter/material.dart';
import 'package:uniket/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniket/bloc/search_history/search_history_bloc.dart';
import 'package:uniket/bloc/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniket/bloc/seller_sold_product/sold_product_bloc.dart';
import 'package:uniket/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniket/main.dart';
import 'network/repository/index.dart';

class StateManagerProvider extends StatelessWidget {
  const StateManagerProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => AuthRepository(DioClient.instance)),
          RepositoryProvider(
              create: (context) => AccountRepository(DioClient.instance)),
          RepositoryProvider(
              create: (context) => ProductRepository(DioClient.instance)),
          RepositoryProvider(
              create: (context) => ChatRepository(DioClient.instance)),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: (context) => AuthBloc(context.read<AuthRepository>())),
          BlocProvider(
            create: (context) => ProductBloc(context.read<ProductRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CategoryBloc(context.read<ProductRepository>()),
          ),
          BlocProvider(
              create: (context) =>
                  HotProductBloc(context.read<ProductRepository>())),
          BlocProvider(
            create: (context) =>
                SearchProductBloc(context.read<ProductRepository>()),
          ),
          BlocProvider(
              create: (context) =>
                  AccountBloc(context.read<AccountRepository>())),
          BlocProvider(
              create: (context) => ChatBloc(context.read<ChatRepository>())),
          BlocProvider(
              create: (context) => MessageBloc(context.read<ChatRepository>())),
          BlocProvider(
            create: (context) => StatusBloc(),
          ),
          BlocProvider(create: (context) => TypingBloc()),
          BlocProvider(
              create: (context) => LikeBloc(context.read<ProductRepository>())),
          BlocProvider(
              create: (context) =>
                  SearchHistoryBloc(context.read<AccountRepository>())),
          BlocProvider(
              create: (context) =>
                  OnSaleProductBloc(context.read<ProductRepository>())),
          BlocProvider(
              create: (context) =>
                  SoldProductBloc(context.read<ProductRepository>())),
          BlocProvider(
              create: (context) =>
                  SellerSaleProductBloc(context.read<ProductRepository>())),
          BlocProvider(
              create: (context) =>
                  SellerSoldProductBloc(context.read<ProductRepository>())),
        ], child: const MyApp()));
  }
}
