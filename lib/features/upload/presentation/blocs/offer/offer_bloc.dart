import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/upload/domain/entities/offer.dart';
import 'package:uniplanet/features/upload/domain/usecases/post_offer_usecase.dart';

part 'offer_event.dart';
part 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final PostOfferUseCase postOfferUseCase;

  OfferBloc({required this.postOfferUseCase}) : super(OfferInitial()) {
    on<PostOffer>((event, emit) async {
      // Await the _postOffer method to ensure it completes before the handler completes
      await _postOffer(event, emit);
    });
  }

  // Ensure async operations are awaited
  Future<void> _postOffer(PostOffer event, Emitter<OfferState> emit) async {
    emit(OfferPostInProgress());
    try {
      await postOfferUseCase(event.offer); // Make sure this is awaited
      emit(OfferPostSuccess());
    } catch (e) {
      emit(OfferPostFailure(e.toString()));
    }
  }
}
