import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';

class Streamer {
  late StreamSubscription _chatStreamSubscription;
  late StreamSubscription _accountStreamSubscription;
  late StreamSubscription? _productStreamSubscription;
  Streamer();
  void addChatListener(BuildContext context) {
    _chatStreamSubscription =
        context.read<ChatBloc>().stream.listen((state) async {
      if (state is CreatedChatRoomState) {
        bool userOnline =
            await SocketService.instance.joinChatAndCheckUserExist(
          chatId: state.chatRoomCreated.id,
          targetUserId: state.chatRoomCreated.seller.id,
        );
        if (userOnline) {
          // Check if the widget is still mounted before proceeding
          if (!context.mounted) return;
          context
              .read<StatusBloc>()
              .add(ConnectedEvent(userId: state.chatRoomCreated.seller.id));
        }
      }
      if (state is LoadedChatRoomState) {
        for (var chatRoom in state.buyingChatRooms) {
          bool isTargetUserOnline = await SocketService.instance
              .joinChatAndCheckUserExist(
                  chatId: chatRoom.id, targetUserId: chatRoom.seller.id);
          if (isTargetUserOnline) {
            if (context.mounted) {
              context
                  .read<StatusBloc>()
                  .add(ConnectedEvent(userId: chatRoom.seller.id));
            }
          }
        }
        for (var chatRoom in state.sellingChatRooms) {
          bool isTargetUserOnline = await SocketService.instance
              .joinChatAndCheckUserExist(
                  chatId: chatRoom.id, targetUserId: chatRoom.buyer.id);
          if (isTargetUserOnline) {
            if (context.mounted) {
              context
                  .read<StatusBloc>()
                  .add(ConnectedEvent(userId: chatRoom.buyer.id));
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
        context.read<ProductBloc>().stream.listen((event) {
      if (event is UpdateChatRoomLastMessageEvent) {
        // context.read<ProductBloc>().add(const ());
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
