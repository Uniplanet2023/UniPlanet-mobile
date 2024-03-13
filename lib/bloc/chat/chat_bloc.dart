import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
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
    on<EmptyUnseenMessageEvent>(
      (event, emit) {
        for (var myChat in state.chatRoomList!) {
          if (myChat.id == event.myChatRoomId) {
            return;
          }
        }
        emit(LoadedChatRoomState(chatRoomList: state.chatRoomList));
      },
    );
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
      chatRoomList: state.chatRoomList,
    ));
    try {
      List<ChatRoom> chatrooms = await _chatRepository.getChatRooms();

      emit(LoadedChatRoomState(
        chatRoomList: chatrooms,
      ));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
      // creating chat room state
      chatRoomList: state.chatRoomList, // previous data
    ));
    try {
      ChatRoom myChatRoom = await _chatRepository.creatingChatRoom(
        sellerId: event.sellerId,
        productId: event.productId,
      );
      // SocketService.socket!
      //     .emit("joinChatRoom", myChatRoom.chatRoom.chatRoomId);
      if (state.chatRoomList != null) {
        state.chatRoomList!.add(myChatRoom);
        emit(CreatedChatRoomState(
          // change the created ChatRoom State
          chatRoomList: state.chatRoomList!,
        ));
      } else {
        throw Exception('room or list is not initialized');
      }
    } catch (e) {
      emit(ErrorChatState(e.toString()));
      throw Exception('creating chat room API error');
    }
  }

  // @override
  // void onChange(Change<ChatBlocState> change) {
  //   super.onChange(change);
  //   print(change);
  // }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
