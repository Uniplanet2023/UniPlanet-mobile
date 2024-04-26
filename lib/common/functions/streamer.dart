import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/network/repository/auth_repository/auth_repo.dart';

class Streamer {
  late StreamSubscription _chatStreamSubscription;
  late StreamSubscription _accountStreamSubscription;
  late StreamSubscription? _productStreamSubscription;
  Streamer();
  void addChatListener(BuildContext context) {
    _chatStreamSubscription =
        context.read<ChatBloc>().stream.listen((state) async {
      if (state is LoadedChatRoomState) {
        for (var chatRoom in state.chatRooms) {
          var targetUserId = chatRoom.seller.id == AuthRepository.userId
              ? chatRoom.buyer.id
              : chatRoom.seller.id;
          bool isTargetUserOnline = await Global.socketService
              .joinChatAndCheckUserExist(
                  chatId: chatRoom.id, targetUserId: targetUserId);
          if (isTargetUserOnline) {
            if (context.mounted) {
              context
                  .read<StatusBloc>()
                  .add(ConnectedEvent(userId: targetUserId));
            }
          }
        }
        _chatStreamSubscription.cancel();
      }
    });
  }

  void addAccountListener(BuildContext context) {
    _accountStreamSubscription =
        context.read<AccountBloc>().stream.listen((event) {
      if (event is UserInfoChangeEvent) {
        context.read<ChatBloc>().add(const LoadChatRoomEvent());
      }
    });
  }

  void addProductListener(BuildContext context) {
    _productStreamSubscription =
        context.read<ProductBloc>().stream.listen((state) {
      if (state is ProductImageUploadedState) {
        log('called');
        context
            .read<OnSaleProductBloc>()
            .add(AddOnSaleProductEvent(product: state.uploadedProduct));
      }
    });
  }

  void disposeChatListener() {
    _chatStreamSubscription.cancel();
  }

  void disposeAccountListener() {
    _accountStreamSubscription.cancel();
  }

  void disposeProductListener() {
    _productStreamSubscription!.cancel();
  }
}
