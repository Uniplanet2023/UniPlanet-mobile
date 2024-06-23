part of 'admin_bloc.dart';

sealed class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetAdvertiserListEvent extends AdminEvent {
  const GetAdvertiserListEvent();
  @override
  List<Object> get props => [];
}

class GetMoreAdvertiserListEvent extends AdminEvent {
  const GetMoreAdvertiserListEvent();
  @override
  List<Object> get props => [];
}
