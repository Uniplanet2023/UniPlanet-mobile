import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_links/uni_links.dart';
import 'package:uniplanet/core/deep_link_handler.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/auth/presention/screens/auth_screen.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/theme/theme_cubit.dart';
import 'package:uniplanet/features/common/presentation/widgets/bottom_bar.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/presention/screens/signup_screen.dart';
import 'package:uniplanet/features/on_boarding/screens/loading_page.dart';
import 'package:uniplanet/features/on_boarding/screens/on_boarding_screen.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/router/router.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';
import 'package:uniplanet/config/statemanager_provider.dart';

void main() async {
  await Initialization.init();
  runApp(const StateManagerProvider());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();
  StreamSubscription<String?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getIt<AuthBloc>().add(const TokenValidationEvent());
    // Handle deep links when the app is resumed or opened from background
    _linkSubscription = linkStream.listen((String? link) {
      if (link != null) {
        _deepLinkHandler.handleInitialDeepLink(link);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    Initialization.socketService.disconnect();
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      if (userData != null) {
        var token = DioHelper.instance.session;
        if (token != null) {
          if (Initialization.socketService.socket.disconnected) {
            Initialization.socketService.connect();
          }
          getIt<ChatBloc>().add(const LoadChatRoomEvent());
        }
      }
    } else if (state == AppLifecycleState.paused) {
      log('paused');
      SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      if (userData != null) {
        var token = DioHelper.instance.session;
        if (token != null) {
          if (Initialization.socketService.socket.connected) {
            Initialization.socketService.disconnect();
          }
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
            home: BlocBuilder<AuthBloc, AuthState>(
                bloc: getIt<AuthBloc>(),
                builder: (context, state) {
                  if (state is Authorized) {
                    return const BottomBar();
                  } else if (state is TokenDoesNotExist) {
                    return const AuthScreen();
                  } else if (state is AuthenticationDeny) {
                    return const OnBoardingScreen();
                  } else if (state is UserNotVerifiedState) {
                    return const SignupScreen();
                  }
                  return const LoadingPage();
                }),
          );
        },
      ),
    );
  }
}
