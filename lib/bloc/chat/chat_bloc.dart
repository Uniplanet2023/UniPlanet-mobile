import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/enums/message_status_enum.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/models/get_chat_room.dart';
// Repositories
import 'package:uniplanet_mobile/network/repository/auth_repository/auth_repo.dart';
import 'package:uniplanet_mobile/network/repository/chat_repository/chat_repo.dart';
// Models
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';
// Bloc Events, States
part 'chat_bloc_event.dart';
part 'chat_bloc_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final ChatRepository _chatRepository;
  // final SocketService _socketService;
  ChatBloc(this._chatRepository) : super(InitChatRoomState()) {
    on<CreateChatRoomEvent>((event, emit) async {
      await _creatingChatRoom(event, emit);
    });
    on<LoadChatRoomEvent>((event, emit) async {
      await _loadChatRooms(event, emit);
    });
    on<UpdateChatRoomLastMessageEvent>((event, emit) {
      _updateChatRoomLastMessage(event, emit);
    });
    on<EmptyUnseenMessageEvent>((event, emit) {
      _emptyUnseenMessage(event, emit);
    });
    on<UpdateUnseenMessageEvent>((event, emit) {
      _updateUnseenMessage(event, emit);
    });
  }

  _emptyUnseenMessage(EmptyUnseenMessageEvent event, emit) {
    int unseenMessages = 0;
    //find chatRoom, buying chatroom or selling chatroom
    for (var chatRoom in state.chatRooms) {
      if (chatRoom.id == event.chatId) {
        unseenMessages = chatRoom.unseenMessageCount;
        chatRoom.unseenMessageCount = 0;
        break;
      }
    }
    AwesomeNotifications().getGlobalBadgeCounter().then((value) {
      if (value > 0) {
        var totalNotification = value - unseenMessages;
        if (totalNotification < 0) {
          totalNotification = 0;
        }
        AwesomeNotifications().setGlobalBadgeCounter(totalNotification);
      }
    });

    emit(EmptyUnseenMessageState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount:
            state.totalUnseenMessageCount - unseenMessages));
  }

  _updateUnseenMessage(UpdateUnseenMessageEvent event, emit) {
    for (var chatRoom in state.chatRooms) {
      if (chatRoom.id == event.chatId) {
        chatRoom.unseenMessageCount++;
        break;
      }
    }

    emit(UpdateUnseenMessageState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount + 1));
  }

  _updateChatRoomLastMessage(UpdateChatRoomLastMessageEvent event, emit) {
    bool isUpdated = false;

    // Update for buyingChatRooms
    List<ChatRoom> updatedChatRooms = state.chatRooms.map((chatRoom) {
      if (chatRoom.id == event.lastMessage.chat) {
        isUpdated = true;
        return chatRoom.copyWith(lastMessage: event.lastMessage);
      }
      return chatRoom;
    }).toList();

    emit(UpdateLastMessageState(
      chatRooms: updatedChatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
    try {
      GetChatRooms? getChatRooms = await _chatRepository.getChatRooms();
      if (getChatRooms == null) {
        emit(const ErrorChatState('Error loading chat rooms'));
        return;
      }

      emit(LoadedChatRoomState(
        chatRooms: getChatRooms.chatRooms,
        totalUnseenMessageCount: getChatRooms.totalUnseenMessageCount,
      ));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
    try {
      ChatRoom chatRoom = await _chatRepository.creatingChatRoom(
        seller: event.seller,
        buyer: event.buyer,
        productId: event.productId,
      );
      Message msg = Message(
        id: '',
        chat: chatRoom.id,
        sender: event.buyer.id,
        receiver: event.seller.id,
        message: '${event.buyer.name} has started a conversation',
        messageType: MessageEnum.text.value,
        status: MessageStatusEnum.received.value,
        createdAt: DateTime.now(),
      );

      bool userOnline =
          await SocketService.instance.chatRoomCreateAndCheckUserExist(
        sender: event.buyer,
        message: msg,
      );
      if (userOnline) {
        // Check if the widget is still mounted before proceeding
        if (!SnackbarGlobal.key.currentContext!.mounted) return;
        SnackbarGlobal.key.currentContext!
            .read<StatusBloc>()
            .add(ConnectedEvent(userId: chatRoom.seller.id));
      }
      state.chatRooms.add(chatRoom);
      emit(CreatedChatRoomState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount,
        chatRoomCreated: chatRoom,
      ));
    } catch (e) {
      emit(ErrorChatState(e.toString()));
      throw Exception('creating chat room API error');
    }
  }

  @override
  void onChange(Change<ChatBlocState> change) {
    super.onChange(change);
    // print(change);
  }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
