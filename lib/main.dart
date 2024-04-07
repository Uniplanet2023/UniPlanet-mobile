import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:uniplanet_mobile/features/category/screens/categories.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/common/routes/router.dart';
import 'package:uniplanet_mobile/network/notification/notification_service.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';
import 'package:uniplanet_mobile/statemanager_provider.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage sdfmessage) async {
  print("Handling a background message:");

  var message = jsonDecode(sdfmessage.data['message']);
  var sender = jsonDecode(sdfmessage.data['sender']);
  await NotificationService.showNotification(
    title: sender['name'],
    body: message['message'],
    payload: {
      "navigate": "true",
      "sender": sdfmessage.data['sender'],
      "message": sdfmessage.data['message'],
    },
  );
}

void main() async {
  await Global.init();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // bool inDebug = false;
    // assert(() {
    //   inDebug = true;
    //   return true;
    // }());
    // if (inDebug) {
    //   return ErrorWidget(details.exception);
    // }
    return const Scaffold(
      body: Center(
        child: Text(
          'An error occurred. Please restart the app.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ),
    );
  };

  runApp(const StateManagerProvider());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey mainContext = GlobalKey();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  splashScreenController() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthBloc>().add(const TokenValidationEvent());
    context.read<ProductBloc>().add(const LoadProductEvent());

    splashScreenController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SocketService.isOnline = true;
      if (SocketService.currentChatLocation != null) {
        SocketService.instance
            .readAllMessages(SocketService.currentChatLocation!);
      }
    } else if (state == AppLifecycleState.paused) {
      SocketService.isOnline = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 360, 780
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackbarGlobal.key,
        navigatorKey: MyApp.navigatorKey,
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
            SocketService.instance.connect();
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
