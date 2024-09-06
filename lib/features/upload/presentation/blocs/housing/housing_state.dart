part of 'housing_bloc.dart';

abstract class HousingState extends Equatable {
  const HousingState();

  @override
  List<Object> get props => [];
}

class HousingInitial extends HousingState {}

// housing post upload
class HousingPostUploading extends HousingState {}

class HousingPostUploaded extends HousingState {}

class HousingImagesUploaded extends HousingState {}

class HousingPostSuccess extends HousingState {
  final HousingPost housingPost;

  const HousingPostSuccess(this.housingPost);

  @override
  List<Object> get props => [housingPost];
}

class HousingError extends HousingState {
  final String message;

  const HousingError(this.message);

  @override
  List<Object> get props => [message];
}
