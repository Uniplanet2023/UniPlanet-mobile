import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/addProduct/screens/admin_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/splash_screen.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/router.dart';

void main() {
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => ChatRepository()),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(
            create: (context) => UserBloc(
                  context.read<UserRepository>(),
                )),
        BlocProvider(
            create: (context) => ChatBloc(
                context.read<ProductRepository>(),
                context.read<UserRepository>(),
                context.read<ChatRepository>())),
      ], child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print('here');
    _loadUser();
  }

  _loadUser() {
    context.read<UserBloc>().add(LoadUserDataEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<UserBloc>().state;
    // print(state == LoadingUserState);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackbarGlobal.key,
      title: 'Uniplanet Marketplace',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
      // home: state is LoadingUserState
      //     ? const AuthScreen()
      //     : state is LoadedUserState
      //         ? const BottomBar()
      //         : const AuthScreen(),

      // state.user!.token != ''
      //     ? state.user!.type == 'user'
      //         ? const BottomBar()
      //         : const AdminScreen()
      //     : const AuthScreen(),
    );
  }
}
