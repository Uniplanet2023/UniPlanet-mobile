import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

part 'message_bloc_event.dart';
part 'message_bloc_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final ChatRepository _chatRepository;
  MessageBloc(this._chatRepository) : super(InitMessageState()) {
    on<GetMessageEvent>((event, emit) async {
      await _loadMessages(event, emit);
    });
  }
  _loadMessages(GetMessageEvent event, emit) async {
    emit(LoadingMessageState(msgList: state.msgList));
    List<Message> msgList =
        await _chatRepository.getMessages(msgList: event.msgList);
    emit(LoadedMessageState(msgList: msgList));
  }

  @override
  void onChange(Change<MessageBlocState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<MessageBlocEvent, MessageBlocState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
