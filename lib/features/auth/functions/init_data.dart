// init.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signin_state.dart';
import 'package:uniplanet_mobile/bloc/auth/auth_state/signup_state.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/bloc/like/like_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_state/get_product.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';

class InitData {
  final BuildContext context;
  bool _isAccountInfoLoaded = false;
  bool _isChatRoomLoaded = false;
  bool _isProductLoaded = false;
  bool _isLikeLoaded = false;
  Timer? _timer;
  final List<StreamSubscription> _subscriptions = [];

  InitData(this.context);

  void initBlocListener() {
    _resetTimer();

    final authSubscription = context.read<AuthBloc>().stream.listen((state) {
      if (state is Authorized) {
        _loadInitialData();
        _resetTimer();
      } else if (state is AuthenticationDeny ||
          state is ValidationFailedState) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.authPage, (route) => false);
      } else if (state is UserNotVerifiedState) {
        Navigator.pushNamed(context, AppRoutes.signupPage);
      }
    });
    _subscriptions.add(authSubscription);

    var accountSubscription =
        context.read<AccountBloc>().stream.listen((state) {
      if (state is GotAccountInfoState) {
        _isAccountInfoLoaded = true;
        _resetTimer();
        _navigateIfReady();
      }
    });
    _subscriptions.add(accountSubscription); // Add this line

    var chatSubscription = context.read<ChatBloc>().stream.listen((state) {
      if (state is LoadedChatRoomState) {
        _isChatRoomLoaded = true;
        _resetTimer();
        _navigateIfReady();
      }
    });
    _subscriptions.add(chatSubscription); // Add this line

    var productSubscription =
        context.read<ProductBloc>().stream.listen((state) {
      if (state is LoadedProductState) {
        _isProductLoaded = true;
        _resetTimer();
        _navigateIfReady();
      }
    });
    _subscriptions.add(productSubscription); // Add this line

    var likeSubscription = context.read<LikeBloc>().stream.listen((state) {
      if (state is LikeLoaded) {
        _isLikeLoaded = true;
        _resetTimer();
        _navigateIfReady();
      }
    });
    _subscriptions.add(likeSubscription); // Add this line
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 10), () {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.authPage, (route) => false);
    });
  }

  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _timer?.cancel();
  }

  void _navigateIfReady() {
    if (_isAccountInfoLoaded &&
        _isChatRoomLoaded &&
        _isProductLoaded &&
        _isLikeLoaded) {
      _timer?.cancel();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.bottomBarPage, (route) => false);
    }
  }

  void _loadInitialData() {
    context.read<ProductBloc>().add(const LoadProductEvent());
    context.read<AccountBloc>().add(const GetAccountInfoEvent());
    context.read<ChatBloc>().add(const LoadChatRoomEvent());
    context.read<LikeBloc>().add(const LoadLikeEvent());
  }
}
