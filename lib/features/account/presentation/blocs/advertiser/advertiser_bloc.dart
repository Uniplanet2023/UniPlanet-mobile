import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/ad_stat_entity.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_ad_interaction_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_ad_statistic_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_advertiser_info_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/advertiser_usecases/get_user_interaction_info_usecase.dart';

part 'advertiser_event.dart';
part 'advertiser_state.dart';

class AdvertiserBloc extends Bloc<AdvertiserEvent, AdvertiserState> {
  final GetAdInteractionUsecase getAdInteractionUsecase;
  final GetAdStatisticUsecase getAdStatisticUsecase;
  final GetAdvertiserInfoUsecase getAdvertiserInfoUsecase;
  final GetUserInteractionInfoUsecase getUserInteractionInfoUsecase;

  AdvertiserBloc(
      {required this.getAdInteractionUsecase,
      required this.getAdStatisticUsecase,
      required this.getAdvertiserInfoUsecase,
      required this.getUserInteractionInfoUsecase})
      : super(AdvertiserInitial(
            advertiser: AdvertiserEntity.initialAdvertiser(),
            adStat: AdStatEntity.initialAdStat(),
            userInteraction: const [])) {
    on<GetAdvertiserInfoEvent>(_getAdvertiserInfoUsecase);
    on<GetMoreUserInteractionEvent>(_getUserInteractionInfoUsecase);
    on<GetAdStatisticEvent>(_getAdStatisticUsecase);
    on<GetUserInteractionEvent>(_getAdInteractionUsecase);
  }

  Future<void> _getAdvertiserInfoUsecase(
      GetAdvertiserInfoEvent event, Emitter<AdvertiserState> emit) async {
    emit(GettingAdvertiserInfoState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    await getAdvertiserInfoUsecase(NoParams()).then((result) {
      result.fold(
        (faliure) {
          emit(FailedToGetAdvertiserInfoState(
              message: faliure.message,
              adStat: state.adStat,
              advertiser: state.advertiser,
              userInteraction: state.userInteraction));
        },
        (advertiser) {
          emit(GotAdvertiserInfoState(
              advertiser: advertiser,
              adStat: state.adStat,
              userInteraction: state.userInteraction));
        },
      );
    });
  }

  // more user interaction event
  Future<void> _getUserInteractionInfoUsecase(
      GetMoreUserInteractionEvent event, Emitter<AdvertiserState> emit) async {
    emit(
      GettingMoreUserInteractionState(
          advertiser: state.advertiser,
          adStat: state.adStat,
          userInteraction: state.userInteraction,
          interactionPage: state.interactionPage),
    );

    int page = state.interactionPage + 1;

    await getUserInteractionInfoUsecase(page).then((result) {
      result.fold((failure) {
        // TODO: a state that can be emitted for errors
      }, (userInteraction) {
        if (userInteraction.isEmpty) {
          emit(EndUserInteractionState(
              advertiser: state.advertiser,
              adStat: state.adStat,
              userInteraction: state.userInteraction,
              interactionPage: state.interactionPage));
        } else {
          emit(GotMoreUserInteractionState(
              advertiser: state.advertiser,
              adStat: state.adStat,
              userInteraction: userInteraction,
              interactionPage: page));
        }
      });
    });
  }

  Future<void> _getAdInteractionUsecase(
      GetUserInteractionEvent event, Emitter<AdvertiserState> emit) async {
    emit(GettingUserInteractionState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    int page = 1;

    await getAdInteractionUsecase(page).then((result) {
      result.fold((failure) {
        // TODO: a state that can be emitted for errors
      }, (userInteraction) {
        if (userInteraction.isEmpty) {
          emit(EndUserInteractionState(
              advertiser: state.advertiser,
              adStat: state.adStat,
              userInteraction: state.userInteraction,
              interactionPage: state.interactionPage));
        } else {
          emit(GotUserInteractionState(
              advertiser: state.advertiser,
              adStat: state.adStat,
              userInteraction: userInteraction));
        }
      });
    });
  }

  Future<void> _getAdStatisticUsecase(
      GetAdStatisticEvent event, Emitter<AdvertiserState> emit) async {
    emit(GettingAdStatisticState(
        advertiser: state.advertiser,
        adStat: state.adStat,
        userInteraction: state.userInteraction));

    await getAdStatisticUsecase(NoParams()).then(
      (result) {
        result.fold((failed) {
          emit(FailedToGetAdStatisticState(
              message: failed.message,
              advertiser: state.advertiser,
              adStat: state.adStat,
              userInteraction: state.userInteraction));
        }, (adStat) {
          emit(GotAdStatisticState(
              advertiser: state.advertiser,
              adStat: adStat,
              userInteraction: state.userInteraction));
        });
      },
    );
  }
}
