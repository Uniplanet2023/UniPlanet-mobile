import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/category/category_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/bloc/serach_product/search_product_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/splash-screen.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/product_repository/product_repo.dart';
import 'package:uniplanet_mobile/common/routes/router.dart';

void main() async {
  await Global.init();
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => AuthRepository(DioClient.instance)),
        RepositoryProvider(
            create: (context) => AccountRepository(DioClient.instance)),
        RepositoryProvider(
            create: (context) => ProductRepository(
                DioClient.instance, CloudinaryPublic('dtgmmfv3d', 'l1zymzfi'))),
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
          create: (context) => CategoryBloc(context.read<ProductRepository>()),
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
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 360, 780
      builder: (context, child) => MaterialApp(
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
      ),
    );
  }
}
