import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/models/get_chat_room.dart';
// Repositories
import 'package:uniplanet/network/repository/chat_repository/chat_repo.dart';
// Models
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user_model.dart';

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
    emit(DeletingChatRoomState(
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));

    state.chatRooms.removeWhere((element) => element.id == event.chatId);
    emit(DeletedChatRoomState(
      deletedChatRoomId: event.chatId,
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
  }

  _deleteChatRoom(DeleteChatRoomEvent event, emit) async {
    try {
      emit(DeletingChatRoomState(
        chatRooms: state.chatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount,
      ));
      String msg = await _chatRepository.deleteChatRoom(chatId: event.chatId);
      if (msg == 'success') {
        state.chatRooms.removeWhere((element) => element.id == event.chatId);

        Global.socketService
            .sendDeleteChatRoomEvent(event.chatId, event.clientId);
        emit(DeletedChatRoomState(
          deletedChatRoomId: event.chatId,
          chatRooms: state.chatRooms,
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
    ));
    state.chatRooms.insert(0, event.chatRoom);
    emit(AddedChatRoomState(
      chatRoomCreated: event.chatRoom,
      chatRooms: state.chatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
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
    // Update for buyingChatRooms
    List<ChatRoom> updatedChatRooms = state.chatRooms.map((chatRoom) {
      if (chatRoom.id == event.lastMessage.chat) {
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

      emit(LoadedChatRoomState(
        chatRooms: getChatRooms.chatRooms,
        totalUnseenMessageCount: getChatRooms.totalUnseenMessageCount,
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
        if (chat.buyer.id == chatRoom.buyer.id &&
            chat.seller.id == chatRoom.seller.id) {
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
