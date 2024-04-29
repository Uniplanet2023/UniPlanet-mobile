import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/widgets/bottom_bar.dart';
import 'package:uniplanet/common/widgets/error_screen.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/features/auth/screens/signup_screen.dart';
import 'package:uniplanet/features/on_boarding/screens/on_boarding_screen.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/common/routes/router.dart';
import 'package:uniplanet/network/notification/firebase_options.dart';
import 'package:uniplanet/network/notification/notification_handler/notification_service.dart';
import 'package:uniplanet/statemanager_provider.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Handling a background message:");
  // await NotificationService.init();
  // if (message.data.containsKey('type')) {
  //   final String type = message.data['type'];
  //   switch (type) {
  //     case 'new message':
  //       newMessageHandler(message);
  //       break;
  //     case 'creating chat':
  //       creatingChatHandler(message);
  //       log('notification');
  //       break;
  //     default:
  //       log('Unable to handle message');
  //   }
  // }
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
  void initialize() async {
    await NotificationService.init();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthBloc>().add(const TokenValidationEvent());
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    log('dispose  called main.dart');
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
      log('resumed');
    } else if (state == AppLifecycleState.paused) {
      log('paused');
      // App is paused (sent to background)
    } else if (state == AppLifecycleState.inactive) {
      log('inactive');
      // App is inactive (terminated)
    } else if (state == AppLifecycleState.detached) {
      log('detached');
      // App is detached (app suspended in the background)
      if (Global.socketService.socket.connected) {
        Global.socketService.disconnect();
      }
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
        title: 'UniPlanet Marketplace',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          fontFamily: GoogleFonts.roboto().fontFamily,
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
            return const OnBoardingScreen();
          } else if (state is UserNotVerifiedState) {
            return const SignupScreen();
          }
          return const OnBoardingScreen();
        }),
      ),
    );
  }
}
