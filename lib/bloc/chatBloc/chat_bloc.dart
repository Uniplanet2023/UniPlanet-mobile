import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final ProductRepository _productRepository;
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  ChatBloc(this._productRepository, this._userRepository, this._chatRepository)
      : super(InitChatRoomState()) {
    on<CreateChatRoomEvent>((event, emit) async {
      await _creatingChatRoom(event, emit);
    });
    on<LoadChatRoomEvent>((event, emit) async {
      await _loadChatRooms(event, emit);
    });
  }
  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
        currentChatRoom: state.currentChatRoom,
        chatRoomList: state.chatRoomList));
    try {} catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
        currentChatRoom: state.currentChatRoom,
        chatRoomList: state.chatRoomList));
    try {
      ChatRoom? room =
          await _chatRepository.creatingChatRoom(receiverId: event.receiverId);
      if (room != null || state.chatRoomList != null) {
        List<ChatRoom> list = state.chatRoomList!;
        list.add(room!);
        emit(CreatedChatRoomState(currentChatRoom: room, chatRoomList: list));
      } else {
        throw Exception('room or list is not initialized');
      }
    } catch (e) {
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
    print(transition);
  }
}
