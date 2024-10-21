import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/features/offer/domain/entities/offer.dart';
import 'package:uniplanet/features/offer/domain/usecases/delete_offer_usecase.dart';
import 'package:uniplanet/features/offer/domain/usecases/get_offers_usecase.dart';

part 'offer_event.dart';
part 'offer_state.dart';

class GetOfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetOffersUseCase getOffersUseCase;
  final DeleteOfferUseCase deleteOfferUseCase;

  GetOfferBloc(
      {required this.getOffersUseCase, required this.deleteOfferUseCase})
      : super(OfferInitial()) {
    on<GetOffersEvent>(_onGetOffers);
    on<RemoveOfferEvent>(_onRemoveOffer);
  }
  Future<void> _onRemoveOffer(
      RemoveOfferEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());

    await deleteOfferUseCase.call(event.offerId);
  }

  Future<void> _onGetOffers(
      GetOffersEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());

    final Either<ServerException, List<Offer>> result =
        await getOffersUseCase.execute(event.page, event.limit);

    result.fold(
      (failure) => emit(
        OfferError(message: failure.message),
      ),
      (offers) => emit(OfferLoaded(offers: offers)),
    );
  }
}
