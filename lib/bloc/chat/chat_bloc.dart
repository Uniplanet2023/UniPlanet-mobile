import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

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
    // on<EmptyUnseenMessageEvent>(
    //   (event, emit) {
    //     for (var myChat in state.chatRoomList!) {
    //       if (myChat.id == event.myChatRoomId) {
    //         return;
    //       }
    //     }
    //     emit(LoadedChatRoomState(chatRoomList: state.chatRoomList));
    //   },
    // );
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
        buyingChatRooms: updatedBuyingChatRooms,
        sellingChatRooms: updatedSellingChatRooms));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(InitChatRoomState());
    try {
      List<ChatRoom> chatrooms = await _chatRepository.getChatRooms();
      if (chatrooms.isNotEmpty) {
        for (var chatRoom in chatrooms) {
          if (chatRoom.seller.id == AuthRepository.userId) {
            state.sellingChatRooms.add(chatRoom);
          } else {
            state.buyingChatRooms.add(chatRoom);
          }
        }
      }

      emit(LoadedChatRoomState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
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
    ));
    try {
      ChatRoom chatRoom = await _chatRepository.creatingChatRoom(
        sellerId: event.sellerId,
        productId: event.productId,
      );
      state.buyingChatRooms.add(chatRoom);
      emit(CreatedChatRoomState(
        buyingChatRooms: state.buyingChatRooms,
        sellingChatRooms: state.sellingChatRooms,
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
