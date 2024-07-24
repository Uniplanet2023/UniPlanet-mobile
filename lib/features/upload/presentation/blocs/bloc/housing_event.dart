part of 'housing_bloc.dart';

abstract class HousingEvent extends Equatable {
  const HousingEvent();

  @override
  List<Object> get props => [];
}

class UploadHousingPostEvent extends HousingEvent {
  final HousingPostForm housingPostForm;

  const UploadHousingPostEvent({required this.housingPostForm});

  @override
  List<Object> get props => [housingPostForm];
}
