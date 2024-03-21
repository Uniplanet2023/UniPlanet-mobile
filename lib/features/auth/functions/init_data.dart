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
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_state/get_product.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class InitData {
  final BuildContext context;
  bool _isAccountInfoLoaded = false;
  bool _isChatRoomLoaded = false;
  bool _isProductLoaded = false;
  final List<StreamSubscription> _subscriptions = [];

  InitData(this.context);

  void initBlocListener() {
    final authSubscription = context.read<AuthBloc>().stream.listen((state) {
      if (state is Authorized) {
        _loadInitialData();
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
        _navigateIfReady();
      }
    });
    _subscriptions.add(accountSubscription); // Add this line

    var chatSubscription = context.read<ChatBloc>().stream.listen((state) {
      if (state is LoadedChatRoomState) {
        _isChatRoomLoaded = true;
        _navigateIfReady();
      }
    });
    _subscriptions.add(chatSubscription); // Add this line

    var productSubscription =
        context.read<ProductBloc>().stream.listen((state) {
      if (state is LoadedProductState) {
        _isProductLoaded = true;
        _navigateIfReady();
      }
    });
    _subscriptions.add(productSubscription); // Add this line
  }

  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void _navigateIfReady() {
    if (_isAccountInfoLoaded && _isChatRoomLoaded && _isProductLoaded) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.bottomBarPage, (route) => false);
    }
  }

  void _loadInitialData() {
    context.read<ProductBloc>().add(const LoadProductEvent());
    context.read<AccountBloc>().add(const GetAccountInfoEvent());
    context.read<ChatBloc>().add(const LoadChatRoomEvent());
  }
}
