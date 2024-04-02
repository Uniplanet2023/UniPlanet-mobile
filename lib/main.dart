import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/common/routes/router.dart';
import 'package:uniplanet_mobile/statemanager_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message:");
}

void main() async {
  await Global.init();
  runApp(const StateManagerProvider());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  splashScreenController() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const TokenValidationEvent());
    context.read<ProductBloc>().add(const LoadProductEvent());
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });
    splashScreenController();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Authorized) {
            return const BottomBar();
          } else if (state is AuthenticationDeny ||
              state is ValidationFailedState) {
            return const AuthScreen();
          } else if (state is UserNotVerifiedState) {
            return const SignupScreen();
          }
          return const AuthScreen();
        }),
      ),
    );
  }
}
