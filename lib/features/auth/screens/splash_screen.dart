import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    final userBloc = context.read<UserBloc>(); // Access UserBloc

    Future.delayed(const Duration(seconds: 2), () {
      Widget route;
      if (userBloc.state is LoadingUserState) {
        route = const AuthScreen();
      } else if (userBloc.state is LoadedUserState) {
        route = const BottomBar();
      } else {
        route = const AuthScreen();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => route),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<UserBloc>().state;
    print(state == LoadingUserState);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.yellow,
              Colors.red,
              Colors.indigo,
              Colors.teal,
            ],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
