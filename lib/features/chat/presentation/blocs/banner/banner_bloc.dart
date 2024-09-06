import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/chat/domain/entities/banner_ad.dart';
import 'package:uniplanet/features/chat/domain/usecases/get_banner_ads_usecase.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBannerAdsUseCase getBannerAdsUseCase;

  BannerBloc({required this.getBannerAdsUseCase}) : super(BannerInitial()) {
    on<GetBannerAdsEvent>((event, emit) async {
      await _getBannerAds(event, emit);
    });
  }
  _getBannerAds(GetBannerAdsEvent event, emit) async {
    emit(BannerLoading());
    final List<BannerAd> bannerAds = await getBannerAdsUseCase();
    emit(BannerLoaded(bannerAds));
  }
}
