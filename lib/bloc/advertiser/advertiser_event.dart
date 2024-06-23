part of 'advertiser_bloc.dart';

sealed class AdvertiserEvent extends Equatable {
  const AdvertiserEvent();

  @override
  List<Object> get props => [];
}

class GetAdvertiserInfoEvent extends AdvertiserEvent {
  const GetAdvertiserInfoEvent();
  @override
  List<Object> get props => [];
}

class GetMoreUserInteractionEvent extends AdvertiserEvent {
  const GetMoreUserInteractionEvent();

  @override
  List<Object> get props => [];
}

class GetAdStatisticEvent extends AdvertiserEvent {
  const GetAdStatisticEvent();

  @override
  List<Object> get props => [];
}

class GetUserInteractionEvent extends AdvertiserEvent {
  const GetUserInteractionEvent();
  @override
  List<Object> get props => [];
}
