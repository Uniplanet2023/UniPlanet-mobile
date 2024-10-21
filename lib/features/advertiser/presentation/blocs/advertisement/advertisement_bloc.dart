// lib/presentation/blocs/advertisement_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/cancel_subscription_usecase.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/edit_advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/get_advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/remove_advertisement.dart';

part 'advertisement_event.dart';
part 'advertisement_state.dart';

class MyAdvertisementBloc
    extends Bloc<AdvertisementEvent, MyAdvertisementState> {
  final GetAdvertisement getAdvertisement;
  final EditAdvertisement editAdvertisement;
  final RemoveAdvertisement removeAdvertisement;
  final CancelSubscriptionUseCase cancelSubscription;

  MyAdvertisementBloc({
    required this.getAdvertisement,
    required this.editAdvertisement,
    required this.removeAdvertisement,
    required this.cancelSubscription,
  }) : super(AdvertisementInitial()) {
    on<GetAdvertisementEvent>(_onGetAdvertisement);
    on<EditAdvertisementEvent>(_onEditAdvertisement);
    on<RemoveAdvertisementEvent>(_onRemoveAdvertisement);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
  }
  void _onCancelSubscription(
      CancelSubscriptionEvent event, Emitter<MyAdvertisementState> emit) async {
    emit(AdvertisementCanceling(advertisements: state.advertisements));
    final result = await cancelSubscription(event.advertisementId);

    result.fold(
      (failure) => emit(ErrorAdvertisementState(
          message: failure.toString(), advertisements: state.advertisements)),
      (_) => emit(AdvertisementCancelled(advertisements: state.advertisements)),
    );
  }

  void _onGetAdvertisement(
      GetAdvertisementEvent event, Emitter<MyAdvertisementState> emit) async {
    emit(LoadingAdvertisementState(advertisements: state.advertisements));
    final failureOrAds = await getAdvertisement(Params(id: event.id));
    emit(failureOrAds.fold(
      (failure) => ErrorAdvertisementState(
          message: 'Error loading advertisement',
          advertisements: state.advertisements),
      (ads) => LoadedAdvertisementState(advertisements: ads),
    ));
  }

  void _onEditAdvertisement(
      EditAdvertisementEvent event, Emitter<MyAdvertisementState> emit) async {
    emit(LoadingAdvertisementState(advertisements: state.advertisements));
    final failureOrVoid = await editAdvertisement(event.advertisement);
    emit(failureOrVoid.fold(
      (failure) => ErrorAdvertisementState(
          message: 'Error editing advertisement',
          advertisements: state.advertisements),
      (_) => AdvertisementEditedState(advertisements: state.advertisements),
    ));
  }

  void _onRemoveAdvertisement(RemoveAdvertisementEvent event,
      Emitter<MyAdvertisementState> emit) async {
    emit(LoadingAdvertisementState(advertisements: state.advertisements));
    final failureOrVoid = await removeAdvertisement(Params(id: event.id));
    emit(failureOrVoid.fold(
      (failure) => ErrorAdvertisementState(
          message: 'Error removing advertisement',
          advertisements: state.advertisements),
      (_) => AdvertisementRemovedState(advertisements: state.advertisements),
    ));
  }
}
