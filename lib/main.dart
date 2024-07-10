import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/theme/theme_cubit.dart';
import 'package:uniplanet/features/common/presentation/widgets/bottom_bar.dart';
import 'package:uniplanet/features/common/presentation/widgets/error_screen.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/screens/signup_screen.dart';
import 'package:uniplanet/features/on_boarding/screens/on_boarding_screen.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/router/router.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/statemanager_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initialization.init();
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
    log('dispose called main.dart');
    Initialization.socketService.disconnect();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      if (userData != null) {
        if (Initialization.socketService.socket.disconnected) {
          Initialization.socketService.connect();
        }
        SnackbarGlobal.key.currentState!.context
            .read<ChatBloc>()
            .add(const LoadChatRoomEvent());
      }
    } else if (state == AppLifecycleState.paused) {
      log('paused');
      SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      if (userData != null) {
        if (Initialization.socketService.socket.connected) {
          Initialization.socketService.disconnect();
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      log('inactive');
    } else if (state == AppLifecycleState.detached) {
      log('detached');
      SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      if (userData != null) {
        if (Initialization.socketService.socket.connected) {
          Initialization.socketService.disconnect();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
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
