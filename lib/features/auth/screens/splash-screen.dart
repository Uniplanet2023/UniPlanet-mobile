import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signin_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product-bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/BottomBar.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
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
    context.read<AuthBloc>().add(const TokenValidationEvent());
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authorized) {
            context.read<ProductBloc>().add(const LoadProductEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          } else if (state is AuthenticationDeny) {
            Navigator.pushNamedAndRemoveUntil(
                context, AuthScreen.routeName, (route) => false);
          }
        },
        child: Container(
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
