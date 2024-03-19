import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signin_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    context.read<AuthBloc>().add(const TokenValidationEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
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
            context.read<AccountBloc>().add(const GetAccountInfoEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.bottomBarPage, (route) => false);
          } else if (state is AuthenticationDeny) {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.authPage, (route) => false);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.4,
                0.6,
                0.9,
              ],
              colors: [
                Colors.orange.shade200,
                Colors.orange.shade200,
                Colors.orange.shade100,
                Colors.orange.shade100,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
