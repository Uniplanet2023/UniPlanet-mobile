import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';
import 'package:uniplanet_mobile/repository/chat_repository/chat_repo.dart';

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
    on<UpdateUnseenMessageEvent>(((event, emit) {
      _updateUnseenMessage(event, emit);
    }));
  }

  _emptyUnseenMessage(EmptyUnseenMessageEvent event, emit) {
    bool isfound = false;
    int unseenMessages = 0;
    //find chatRoom, buying chatroom or selling chatroom
    for (var chatRoom in state.buyingChatRooms) {
      if (chatRoom.id == event.chatId) {
        isfound = true;
        unseenMessages = chatRoom.unseenMessageCount;
        chatRoom.unseenMessageCount = 0;
        break;
      }
    }
    if (!isfound) {
      for (var chatRoom in state.sellingChatRooms) {
        if (chatRoom.id == event.chatId) {
          unseenMessages = chatRoom.unseenMessageCount;
          chatRoom.unseenMessageCount = 0;
          break;
        }
      }
    }

    emit(EmptyUnseenMessageState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
        totalUnseenMessageCount:
            state.totalUnseenMessageCount - unseenMessages));
  }

  _updateUnseenMessage(UpdateUnseenMessageEvent event, emit) {
    bool isfound = false;
    //find chatRoom, buying chatroom or selling chatroom
    for (var chatRoom in state.buyingChatRooms) {
      if (chatRoom.id == event.chatId) {
        isfound = true;
        chatRoom.unseenMessageCount++;
        break;
      }
    }
    if (!isfound) {
      for (var chatRoom in state.sellingChatRooms) {
        if (chatRoom.id == event.chatId) {
          chatRoom.unseenMessageCount++;
          break;
        }
      }
    }

    emit(UpdateUnseenMessageState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount + 1));
  }

  _updateChatRoomLastMessage(UpdateChatRoomLastMessageEvent event, emit) {
    bool isUpdated = false;

    // Update for buyingChatRooms
    List<ChatRoom> updatedBuyingChatRooms =
        state.buyingChatRooms.map((chatRoom) {
      if (chatRoom.id == event.lastMessage.chat) {
        isUpdated = true;
        return chatRoom.copyWith(lastMessage: event.lastMessage);
      }
      return chatRoom;
    }).toList();

    // If the chatRoom was found and updated in buyingChatRooms, we can skip updating sellingChatRooms
    List<ChatRoom> updatedSellingChatRooms = isUpdated
        ? state.sellingChatRooms
        : state.sellingChatRooms.map((chatRoom) {
            if (chatRoom.id == event.lastMessage.chat) {
              return chatRoom.copyWith(lastMessage: event.lastMessage);
            }
            return chatRoom;
          }).toList();

    emit(UpdateLastMessageState(
        totalUnseenMessageCount: state.totalUnseenMessageCount,
        buyingChatRooms: updatedBuyingChatRooms,
        sellingChatRooms: updatedSellingChatRooms));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(InitChatRoomState());
    try {
      List<ChatRoom> chatrooms = await _chatRepository.getChatRooms();
      var totalUnseenMessageCount = 0;
      if (chatrooms.isNotEmpty) {
        for (var chatRoom in chatrooms) {
          if (chatRoom.seller.id == AuthRepository.userId) {
            state.sellingChatRooms.add(chatRoom);
            totalUnseenMessageCount += chatRoom.unseenMessageCount;
          } else {
            state.buyingChatRooms.add(chatRoom);
            totalUnseenMessageCount += chatRoom.unseenMessageCount;
          }
        }
      }

      emit(LoadedChatRoomState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
        totalUnseenMessageCount: totalUnseenMessageCount,
      ));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
      buyingChatRooms: state.buyingChatRooms,
      sellingChatRooms: state.sellingChatRooms,
      totalUnseenMessageCount: state.totalUnseenMessageCount,
    ));
    try {
      ChatRoom chatRoom = await _chatRepository.creatingChatRoom(
        seller: event.seller,
        buyer: event.buyer,
        productId: event.productId,
      );
      state.buyingChatRooms.add(chatRoom);
      emit(CreatedChatRoomState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
        totalUnseenMessageCount: state.totalUnseenMessageCount,
      ));
    } catch (e) {
      emit(ErrorChatState(e.toString()));
      throw Exception('creating chat room API error');
    }
  }

  @override
  void onChange(Change<ChatBlocState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
