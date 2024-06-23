import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/theme/theme_cubit.dart';
import 'package:uniplanet/common/widgets/bottom_bar.dart';
import 'package:uniplanet/common/widgets/error_screen.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/features/auth/screens/signup_screen.dart';
import 'package:uniplanet/features/on_boarding/screens/on_boarding_screen.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/common/routes/router.dart';
import 'package:uniplanet/statemanager_provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthBloc>().add(const TokenValidationEvent());
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
      if (Global.socketService.socket.disconnected) {
        Global.socketService.connect();
      }
      SnackbarGlobal.key.currentState!.context
          .read<ChatBloc>()
          .add(const LoadChatRoomEvent());
    } else if (state == AppLifecycleState.paused) {
      log('paused');
      // App is paused (sent to background)
      if (Global.socketService.socket.connected) {
        Global.socketService.disconnect();
      }
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
      builder: (context, child) => BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: SnackbarGlobal.key,
            navigatorKey: MyApp.navigatorKey,
            title: 'UniPlanet Marketplace',
            theme: state,
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
          );
        },
      ),
    );
  }
}
