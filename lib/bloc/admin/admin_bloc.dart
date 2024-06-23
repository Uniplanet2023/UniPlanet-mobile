import 'package:equatable/equatable.dart';
import 'package:uniplanet/api/repository/account_repository/account_repo.dart';
import 'package:uniplanet/bloc/index.dart';
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
