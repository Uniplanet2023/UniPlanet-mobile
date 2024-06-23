import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/api/repository/account_repository/account_repo.dart';
import 'package:uniplanet/models/ad_stat.dart';
import 'package:uniplanet/models/advertiser.dart';
import 'package:uniplanet/models/user_interaction.dart';

part 'advertiser_event.dart';
part 'advertiser_state.dart';

class AdvertiserBloc extends Bloc<AdvertiserEvent, AdvertiserState> {
  final AccountRepository _accountRepository;

  AdvertiserBloc(this._accountRepository)
      : super(AdvertiserInitial(
            advertiser: Advertiser.initialAdtertiser(),
            adStat: AdStat.initialAdtertiser(),
            userInteraction: const [])) {
    on<GetAdvertiserInfoEvent>((event, emit) async {
      await _getAdvertiserInfo(emit, event);
    });
    on<GetAdStatisticEvent>((event, emit) async {
      await _getAdStatistic(emit, event);
    });
    on<GetUserInteractionEvent>((event, emit) async {
      await _getAdInteraction(emit, event);
    });
  }
  _getAdInteraction(emit, GetUserInteractionEvent event) async {
    emit(GettingUserInteractionState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    List<UserInteraction> userInteraction =
        await _accountRepository.getAdInteraction(page: 1);

    emit(GotUserInteractionState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: userInteraction));
  }

  _getAdvertiserInfo(emit, GetAdvertiserInfoEvent event) async {
    emit(GettingAdvertiserInfoState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    Advertiser? advertiser = await _accountRepository.getAdvertiser();

    if (advertiser != null) {
      emit(GotAdvertiserInfoState(
          advertiser: advertiser,
          adStat: state.adStat,
          userInteraction: state.userInteraction));
    } else {
      emit(FailedToGetAdvertiserInfoState(
          message: 'Failed to get advertiser info',
          adStat: state.adStat,
          advertiser: state.advertiser,
          userInteraction: state.userInteraction));
    }
  }

  _getAdStatistic(emit, GetAdStatisticEvent event) async {
    emit(GettingAdStatisticState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    AdStat? adStat = await _accountRepository.getAdStatistic();
    if (adStat == null) {
      emit(FailedToGetAdStatisticState(
          message: 'Failed to get ad statistic',
          advertiser: state.advertiser,
          adStat: state.adStat,
          userInteraction: state.userInteraction));
      return;
    }

    emit(GotAdStatisticState(
        advertiser: state.advertiser,
        adStat: adStat,
        userInteraction: state.userInteraction));
  }
}
