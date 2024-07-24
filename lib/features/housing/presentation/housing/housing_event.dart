part of 'housing_bloc.dart';

sealed class GetHousingEvent extends Equatable {
  const GetHousingEvent();

  @override
  List<Object> get props => [];
}

class FetchHousingPosts extends GetHousingEvent {}

class FetchMoreHousingPosts extends GetHousingEvent {}

class GetMyHousingPosts extends GetHousingEvent {}

class GetMoreMyHousingPosts extends GetHousingEvent {}

class DeleteHousingPostEvent extends GetHousingEvent {
  final String id;
  const DeleteHousingPostEvent({required this.id});
}

class FetchHousingPostEvent extends GetHousingEvent {
  final String housingId;
  const FetchHousingPostEvent({required this.housingId});
}
