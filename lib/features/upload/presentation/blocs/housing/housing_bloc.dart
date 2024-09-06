import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/core/helper/image_upload_helper.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';
import 'package:uniplanet/features/upload/domain/usecases/update_housing_post.dart';
import 'package:uniplanet/features/upload/domain/usecases/upload_housing_post.dart';

part 'housing_event.dart';
part 'housing_state.dart';

class HousingBloc extends Bloc<HousingEvent, HousingState> {
  final UploadHousingPost uploadHousingPost;
  final UpdateHousingPost updateHousingPost;

  HousingBloc({
    required this.uploadHousingPost,
    required this.updateHousingPost,
  }) : super(HousingInitial()) {
    on<UploadHousingPostEvent>(_onUploadHousingPost);
  }

  void _onUploadHousingPost(
      UploadHousingPostEvent event, Emitter<HousingState> emit) async {
    emit(HousingPostUploading());
    try {
      HousingPost? housingPost = await uploadHousingPost(event.housingPostForm);
      if (housingPost == null) {
        emit(const HousingError("Failed to upload post"));
        return;
      }
      emit(HousingPostUploaded());
      List<String> imageList = await ImageUploadHelper.instance.uploadImages(
          images: event.housingPostForm.images, post: Right(housingPost));
      emit(HousingImagesUploaded());
      housingPost = housingPost.copyWith(images: imageList);
      final HousingPost? housingPosts = await updateHousingPost(housingPost);
      if (housingPosts == null) {
        emit(const HousingError("Failed to upload post"));
        return;
      }
      emit(HousingPostSuccess(housingPosts));
    } catch (e) {
      emit(HousingError(e.toString()));
    }
  }
}
