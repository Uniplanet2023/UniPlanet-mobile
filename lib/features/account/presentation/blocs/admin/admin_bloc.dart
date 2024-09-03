import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/block_post_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/get_advertiser_list_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/get_more_advertiser_list_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/admin_usecases/increase_credit_usecase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final BlockPostUsecase blockPostUsecase;
  final GetAdvertiserListUsecase getAdvertiserListUsecase;
  final GetMoreAdvertiserListUsecase getMoreAdvertiserListUsecase;
  final IncreaseCreditUsecase increaseCreditUsecase;

  AdminBloc({
    required this.blockPostUsecase,
    required this.getAdvertiserListUsecase,
    required this.getMoreAdvertiserListUsecase,
    required this.increaseCreditUsecase,
  }) : super(const AdminInitial(advertiserList: [])) {
    on<BlockControlEvent>(_onBlocControl);
    on<GetAdvertiserListEvent>(_onGetAdvertiserList);
    on<GetMoreAdvertiserListEvent>(_onGetMoreAdvertiserList);
    on<IncreaseCreditEvent>(_onIncreaseCredit);
  }

  Future<void> _onBlocControl(
      BlockControlEvent event, Emitter<AdminState> emit) async {
    emit(PostingBlockControlState(
        advertiserList: state.advertiserList, page: state.page));

    await blockPostUsecase(BlockPostParams(
            accountId: event.accountId,
            isPostBlock: event.isPostBlock!,
            isChatBlock: event.isChatBlock!,
            isBlock: event.isBlock!))
        .then((result) {
      result.fold((failed) {
        emit(FailedToPostBlockControlState(
            message: "Failed to update block status",
            advertiserList: state.advertiserList,
            page: state.page));
      }, (advertiser) {
        emit(PostedBlockControlState(
            advertiser: advertiser,
            advertiserList: state.advertiserList,
            page: state.page));
      });
    });
  }

  Future<void> _onGetAdvertiserList(
      GetAdvertiserListEvent event, Emitter<AdminState> emit) async {
    emit(GettingAdvertiserListState(
        advertiserList: state.advertiserList, page: 1));

    int page = 1;
    await getAdvertiserListUsecase(page).then((result) {
      result.fold((failed) {
        emit(EndAdvertiserListState(
          advertiserList: state.advertiserList,
          page: 1,
        ));
      }, (advertiserList) {
        emit(GotAdvertiserListState(
          advertiserList: advertiserList,
          page: 1,
        ));
      });
    });
  }

  Future<void> _onGetMoreAdvertiserList(
      GetMoreAdvertiserListEvent event, Emitter<AdminState> emit) async {
    emit(GettingMoreAdvertiserListState(
        advertiserList: state.advertiserList, page: state.page));

    int nextPage = state.page + 1;

    await getMoreAdvertiserListUsecase(nextPage).then((result) {
      result.fold((failed) {
        emit(EndAdvertiserListState(
          advertiserList: state.advertiserList,
          page: state.page,
        ));
      }, (advertiserList) {
        emit(GotMoreAdvertiserListState(
          advertiserList: advertiserList,
          page: nextPage,
        ));
      });
    });
  }

  Future<void> _onIncreaseCredit(
      IncreaseCreditEvent event, Emitter<AdminState> emit) async {
    emit(IncreasingCreditState(
        advertiserList: state.advertiserList, page: state.page));

    await increaseCreditUsecase(IncreaseCreditParams(
            advertiserAccountId: event.accountId,
            freeCredit: event.freeCredit,
            credit: event.credit))
        .then((result) {
      result.fold((failed) {
        emit(FailedToIncreaseCreditState(
          message: "Failed to Increase Credit!",
          advertiserList: state.advertiserList,
          page: state.page,
        ));
      }, (advertiser) {
        emit(IncreasedCreditState(
            advertiser: advertiser,
            advertiserList: state.advertiserList,
            page: state.page));
      });
    });
  }
}
