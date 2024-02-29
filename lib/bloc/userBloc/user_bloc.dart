// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uniplanet_mobile/models/user.dart';
// import 'package:uniplanet_mobile/repository/user_repo.dart';

// part 'user_bloc_event.dart';
// part 'user_bloc_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UserRepository _userRepository;
//   // final SocketService _socketService;
//   UserBloc(this._userRepository) : super(UserInitialState()) {
//     on<LoadUserDataEvent>((event, emit) async {
//       await _loadingUserFunction(event, emit);
//     });
//     on<UpdateUserNotificationEvent>((event, emit) async {
//       await _updateUserFunction(event, emit);
//     });
//   }

//   _updateUserFunction(UpdateUserNotificationEvent event, emit) async {
//     emit(const LoadedUserState());
//   }

//   _loadingUserFunction(LoadUserDataEvent event, emit) async {
//     emit(LoadingUserState(user: state.user));
//     // User user = await _userRepository.getUserData();
//     // if (user.token != '') {
//     //   emit(LoadedUserState(
//     //       user: user, unSeenMessageNum: state.unSeenMessageNum));
//     // } else {
//     //   emit(const ErrorUserState('No User Data'));
//     // }
//   }

//   //Tracking
//   @override
//   void onChange(Change<UserState> change) {
//     super.onChange(change);
//   }

//   @override
//   void onTransition(Transition<UserEvent, UserState> transition) {
//     super.onTransition(transition);
//     // print(transition);
//   }
// }
