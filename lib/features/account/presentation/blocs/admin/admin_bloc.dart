import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/network/repository/account_repository/account_repo.dart';
import 'package:uniplanet/models/advertiser.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AccountRepository _accountRepository;
  AdminBloc(this._accountRepository)
      : super(const AdminInitial(advertiserList: [])) {
    on<GetAdvertiserListEvent>((event, emit) async {
      await _getAdvertiserList(emit, event);
    });
    on<GetMoreAdvertiserListEvent>((event, emit) async {
      await _getMoreAdvertiserList(emit, event);
    });
    on<IncreaseCreditEvent>((event, emit) async {
      await _increaseCredit(emit, event);
    });
    on<BlockControlEvent>((event, emit) async {
      await _blockControl(emit, event);
    });
  }
  //postBlockControl
  _blockControl(emit, BlockControlEvent event) async {
    emit(PostingBlockControlState(
        advertiserList: state.advertiserList, page: state.page));

    Advertiser? advertiser = await _accountRepository.blockControl(
      accountId: event.accountId,
      isPostBlock: event.isPostBlock,
      isChatBlock: event.isChatBlock,
      isBlock: event.isBlock,
    );

    if (advertiser != null) {
      emit(PostedBlockControlState(
          advertiser: advertiser,
          advertiserList: state.advertiserList,
          page: state.page));
    } else {
      emit(FailedToPostBlockControlState(
          message: "Failed to update block status",
          advertiserList: state.advertiserList,
          page: state.page));
    }
  }

  _increaseCredit(emit, IncreaseCreditEvent event) async {
    emit(IncreasingCreditState(
        advertiserList: state.advertiserList, page: state.page));

    Advertiser? advertiser = await _accountRepository.increaseCredit(
        advertiserAccountId: event.accountId,
        freeCredit: event.freeCredit,
        credit: event.credit);

    if (advertiser != null) {
      emit(IncreasedCreditState(
          advertiser: advertiser,
          advertiserList: state.advertiserList,
          page: state.page));
    }
  }

  _getAdvertiserList(emit, event) async {
    emit(GettingAdvertiserListState(
        advertiserList: state.advertiserList, page: 1));

    List<Advertiser> advertiserList =
        await _accountRepository.getAdvertiserList();

    if (advertiserList.isEmpty) {
      emit(EndAdvertiserListState(
          advertiserList: state.advertiserList, page: 1));
      return;
    } else {
      emit(GotAdvertiserListState(advertiserList: advertiserList, page: 1));
    }
  }

  _getMoreAdvertiserList(emit, event) async {
    emit(GettingMoreAdvertiserListState(
        advertiserList: state.advertiserList, page: state.page));
    int nextPage = state.page + 1;
    List<Advertiser> advertiserList =
        await _accountRepository.getAdvertiserList();

    if (advertiserList.isEmpty) {
      emit(EndAdvertiserListState(
          advertiserList: state.advertiserList, page: state.page));
      return;
    } else {
      emit(GotMoreAdvertiserListState(
          advertiserList: advertiserList, page: nextPage));
    }
  }
}
