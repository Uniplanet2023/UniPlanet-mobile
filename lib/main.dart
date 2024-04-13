import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/common/widgets/error_screen.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/common/routes/router.dart';
import 'package:uniplanet_mobile/network/notification/notification_handler/index.dart';
import 'package:uniplanet_mobile/statemanager_provider.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message:");

  if (message.data.containsKey('type')) {
    final String type = message.data['type'];
    switch (type) {
      case 'new message':
        newMessageHandler(message);
        break;
      case 'creating chat':
        creatingChatHandler(message);
        debugPrint('notification');
        break;
      default:
        debugPrint('Unable to handle message');
    }
  }
}

void main() async {
  await Global.init();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) {
      return ErrorWidget(details.exception);
    }
    return const ErrorScreen();
  };

  runApp(const StateManagerProvider());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    print('dispose  called main.dart');
    Global.socketService.disconnect();
    WidgetsBinding.instance.removeObserver(this);
  }

  // This is the callback that is called when the system puts the app in the background
  // Resume : inactivity -> resume
  // Pause : inactivity -> pause
  // Detached : inactivity -> detached
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
    } else if (state == AppLifecycleState.paused) {
      print('paused');
      // App is paused (sent to background)
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      // App is inactive (terminated)
    } else if (state == AppLifecycleState.detached) {
      print('detached');
      // App is detached (app suspended in the background)
      Global.socketService.disconnect();
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
