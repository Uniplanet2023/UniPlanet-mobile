import 'dart:async';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';

class Streamer {
  late StreamSubscription _chatStreamSubscription;
  late StreamSubscription _accountStreamSubscription;
  late StreamSubscription? _productStreamSubscription;
  Streamer();
  void addChatListener() {
    _chatStreamSubscription = getIt<ChatBloc>().stream.listen((state) async {
      if (state is LoadedChatRoomState) {
        for (var chatRoom in state.chatRooms) {
          var targetUserId = chatRoom.seller.id == AuthRepository.userId
              ? chatRoom.buyer.id
              : chatRoom.seller.id;
          bool isTargetUserOnline = await Initialization.socketService
              .joinChatAndCheckUserExist(
                  chatId: chatRoom.id, targetUserId: targetUserId);
          if (isTargetUserOnline) {
            getIt<StatusBloc>().add(ConnectedEvent(userId: targetUserId));
          }
        }
        _chatStreamSubscription.cancel();
      }
    });
  }

  void addAccountListener() {
    _accountStreamSubscription = getIt<AccountBloc>().stream.listen((event) {
      if (event is UserInfoChangeEvent) {
        getIt<ChatBloc>().add(const LoadChatRoomEvent());
      }
    });
  }

  void addProductListener() {
    _productStreamSubscription = getIt<ProductBloc>().stream.listen((state) {
      if (state is ProductImageUploadedState) {
        log('called');
        getIt<OnSaleProductBloc>()
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
