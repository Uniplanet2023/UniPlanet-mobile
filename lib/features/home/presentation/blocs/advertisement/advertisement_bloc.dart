import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/home/domain/entities/advertisement.dart';
import 'package:uniplanet/features/home/domain/use_cases/get_ads_usecase.dart';

part 'advertisement_event.dart';
part 'advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  GetAdsUseCase getAdsUseCase;
  AdvertisementBloc({required this.getAdsUseCase})
      : super(const AdvertisementInitial()) {
    on<GetAdvertisementEvent>((event, emit) async {
      await _getAds(event, emit);
    });
  }
  _getAds(GetAdvertisementEvent event, Emitter<AdvertisementState> emit) async {
    emit(const AdvertisementLoading());
    try {
      final ads = await getAdsUseCase(type: event.type);
      emit(AdvertisementLoaded(ads: ads));
    } catch (e) {
      emit(AdvertisementError(e.toString()));
    }
  }

  //on Change
  @override
  void onChange(Change<AdvertisementState> change) {
    super.onChange(change);
  }
}
