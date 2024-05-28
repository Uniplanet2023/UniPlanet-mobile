import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/models/get_chat_room.dart';
// Repositories
// Models
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user.dart';
import 'package:uniplanet/api/repository/index.dart';

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
    on<LoadMoreChatRoomEvent>((event, emit) async {
      await _loadMoreChatRooms(event, emit);
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
    on<AddChatRoomEvent>((event, emit) {
      _addChatRoom(event, emit);
    });
    on<DeleteChatRoomEvent>((event, emit) async {
      await _deleteChatRoom(event, emit);
    });
    on<DeletedChatByClient>((event, emit) {
      _deleteChatByClient(event, emit);
    });
  }

  _deleteChatByClient(DeletedChatByClient event, emit) {
    // Emit DeletingChatRoomState to indicate deletion in progress
    emit(DeletingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));

    // Create a new list of chat rooms with the updated `deletedFrom` field
    final updatedChatRooms = state.chatRooms.map((chatRoom) {
      if (chatRoom.id == event.chatId) {
        return chatRoom.copyWith(
          deletedFrom: event.clientId,
        );
      }
      return chatRoom;
    }).toList();

    // Emit DeletedChatRoomState with the updated chat rooms list
    emit(DeletedChatRoomState(
      deletedChatRoomId: event.chatId,
      chatRooms: updatedChatRooms,
      page: state.page,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
  }

  _deleteChatRoom(DeleteChatRoomEvent event, emit) async {
    try {
      emit(DeletingChatRoomState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount,
        page: state.page,
      ));
      String msg = await _chatRepository.deleteChatRoom(chatId: event.chatId);
      if (msg == 'success') {
        state.chatRooms.removeWhere((element) => element.id == event.chatId);

        Global.socketService
            .sendDeleteChatRoomEvent(event.chatId, event.clientId);
        emit(DeletedChatRoomState(
          deletedChatRoomId: event.chatId,
          chatRooms: state.chatRooms,
          page: state.page,
          totalUnseenMessageCount: state.totalUnseenMessageCount,
        ));
      } else {
        SnackbarGlobal.showSnackBar('Failed to delete chat room');
        emit(const ErrorChatState('Failed to delete chat room'));
      }
    } catch (e) {
      emit(ErrorChatState(e.toString()));
      throw Exception('delete chat room API error');
    }
  }

  _addChatRoom(AddChatRoomEvent event, emit) {
    emit(AddingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
    state.chatRooms.insert(0, event.chatRoom);
    emit(AddedChatRoomState(
      chatRoomCreated: event.chatRoom,
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
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
        page: state.page,
        totalUnseenMessageCount:
            state.totalUnseenMessageCount - unseenMessages));
  }

  _updateUnseenMessage(UpdateUnseenMessageEvent event, emit) {
    emit(UpdatingUnseenMessageState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));

    for (var chatRoom in state.chatRooms) {
      if (chatRoom.id == event.chatId) {
        chatRoom.unseenMessageCount++;
        break;
      }
    }
    int toatalUnseenMessageCount = state.totalUnseenMessageCount + 1;

    AwesomeNotifications().setGlobalBadgeCounter(toatalUnseenMessageCount);

    emit(UpdateUnseenMessageState(
        chatRooms: state.chatRooms,
        page: state.page,
        totalUnseenMessageCount: toatalUnseenMessageCount));
  }

  _updateChatRoomLastMessage(UpdateChatRoomLastMessageEvent event, emit) {
    // Find the index of the chat room that needs to be updated
    int? updatedChatRoomIndex = state.chatRooms
        .indexWhere((chatRoom) => chatRoom.id == event.lastMessage.chat);

    // Copy the list to avoid modifying the original list directly
    List<ChatRoom> updatedChatRooms = List<ChatRoom>.from(state.chatRooms);

    // Check if the chat room is found
    if (updatedChatRoomIndex != -1) {
      // Update the chat room with the new last message
      ChatRoom updatedChatRoom = updatedChatRooms[updatedChatRoomIndex]
          .copyWith(lastMessage: event.lastMessage);

      // Remove the updated chat room from its original position
      updatedChatRooms.removeAt(updatedChatRoomIndex);

      // Insert the updated chat room at the front of the list
      updatedChatRooms.insert(0, updatedChatRoom);
    }

    // Emit the new state with the reordered chat rooms
    emit(UpdateLastMessageState(
      chatRooms: updatedChatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
    try {
      GetChatRooms getChatRooms = await _chatRepository.getChatRooms(page: 1);
      AwesomeNotifications()
          .setGlobalBadgeCounter(getChatRooms.totalUnseenMessageCount);
      emit(LoadedChatRoomState(
        chatRooms: getChatRooms.chatRooms,
        totalUnseenMessageCount: getChatRooms.totalUnseenMessageCount,
        page: state.page,
      ));
    } catch (e) {
      log(e);
      throw Exception('Loading chat room API error');
    }
  }

  _loadMoreChatRooms(LoadMoreChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
    try {
      int nextPage = state.page + 1;
      GetChatRooms getChatRooms =
          await _chatRepository.getChatRooms(page: nextPage);
      if (getChatRooms.chatRooms.isEmpty) {
        emit(EndChatRoomState(
          chatRooms: state.chatRooms,
          totalUnseenMessageCount: state.totalUnseenMessageCount,
          page: state.page,
        ));
        return;
      }

      for (var chatRoom in getChatRooms.chatRooms) {
        String clientId;
        if (chatRoom.buyer.id == AuthRepository.userId) {
          clientId = chatRoom.seller.id;
        } else {
          clientId = chatRoom.buyer.id;
        }
        bool isTargetUserOnline = await Global.socketService
            .joinChatAndCheckUserExist(
                chatId: chatRoom.id, targetUserId: clientId);
        if (isTargetUserOnline) {
          if (SnackbarGlobal.key.currentContext!.mounted) {
            SnackbarGlobal.key.currentContext!
                .read<StatusBloc>()
                .add(ConnectedEvent(userId: clientId));
          }
        }
      }

      state.chatRooms.addAll(getChatRooms.chatRooms);
      emit(LoadedChatRoomState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount +
            getChatRooms.totalUnseenMessageCount,
        page: nextPage,
      ));
    } catch (e) {
      log(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
      page: state.page,
    ));
    try {
      ChatRoom chatRoom = await _chatRepository.creatingChatRoom(
        seller: event.seller,
        buyer: event.buyer,
        productId: event.productId,
        productName: event.productName,
      );
      bool isChatRoomExist = false;
      for (var chat in state.chatRooms) {
        if (chat.id == chatRoom.id) {
          isChatRoomExist = true;
          break;
        }
      }
      if (isChatRoomExist == false) {
        state.chatRooms.insert(0, chatRoom);
      }
      emit(CreatedChatRoomState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount,
        chatRoomCreated: chatRoom,
        page: state.page,
      ));
    } catch (e) {
      emit(ErrorChatState(e.toString()));
      throw Exception('creating chat room API error');
    }
  }

  @override
  void onChange(Change<ChatBlocState> change) {
    super.onChange(change);
    log(change);
  }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}
