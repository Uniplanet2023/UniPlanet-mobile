part of 'admin_bloc.dart';

sealed class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetAdvertiserListEvent extends AdminEvent {
  const GetAdvertiserListEvent();
  @override
  List<Object> get props => [];
}

class GetMoreAdvertiserListEvent extends AdminEvent {
  const GetMoreAdvertiserListEvent();
  @override
  List<Object> get props => [];
}

class IncreaseFreeCredit extends AdminEvent {
  final String userId;
  final int credit;
  const IncreaseFreeCredit(this.userId, this.credit);
  @override
  List<Object> get props => [userId, credit];
}

class IncreaseCreditEvent extends AdminEvent {
  final String accountId;
  final double credit;
  final double freeCredit;
  const IncreaseCreditEvent(
      {required this.accountId,
      required this.credit,
      required this.freeCredit});
  @override
  List<Object> get props => [accountId, credit, freeCredit];
}

class BlockControlEvent extends AdminEvent {
  final String accountId;
  final bool? isPostBlock;
  final bool? isChatBlock;
  final bool? isBlock;

  const BlockControlEvent(
      {required this.accountId,
      this.isPostBlock,
      this.isChatBlock,
      this.isBlock});
  @override
  List<Object> get props => [accountId];
}
