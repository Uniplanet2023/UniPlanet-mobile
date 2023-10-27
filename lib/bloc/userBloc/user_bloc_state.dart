part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;
  const UserState({this.user});
}

final class UserInitialState extends UserState {
  UserInitialState()
      : super(
            user: User(
                id: '',
                name: '',
                email: '',
                profileImage: '',
                password: '',
                school: '',
                verified: false,
                isOnline: false,
                unseenNotifications: [],
                unseenMessages: [],
                like: [],
                selling: [],
                bought: [],
                sold: [],
                chatRooms: [],
                type: '',
                token: ''));
  @override
  List<Object?> get props => [user];
}

final class LoadingUserState extends UserState {
  const LoadingUserState({super.user});
  @override
  List<Object?> get props => [user];
}

final class LoadedUserState extends UserState {
  const LoadedUserState({super.user});
  @override
  List<Object?> get props => [user];
}

class ErrorUserState extends UserState {
  final String errMsg;
  const ErrorUserState(this.errMsg);
  @override
  List<Object?> get props => [];
}
