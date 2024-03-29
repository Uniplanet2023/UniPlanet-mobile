import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/main.dart';
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
              create: (context) => ProductRepository(DioClient.instance,
                  CloudinaryPublic('dtgmmfv3d', 'l1zymzfi'))),
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
        ], child: const MyApp()));
  }
}
