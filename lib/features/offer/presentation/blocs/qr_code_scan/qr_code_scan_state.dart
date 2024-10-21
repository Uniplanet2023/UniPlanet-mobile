part of 'qr_code_scan_bloc.dart';

sealed class QrCodeScanState extends Equatable {
  const QrCodeScanState();

  @override
  List<Object> get props => [];
}

class QrCodeScanInitial extends QrCodeScanState {}

class QrCodeScanLoading extends QrCodeScanState {}

class QrCodeScanSuccess extends QrCodeScanState {
  final String message;

  const QrCodeScanSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class QrCodeScanFailure extends QrCodeScanState {
  final String error;

  const QrCodeScanFailure(this.error);

  @override
  List<Object> get props => [error];
}
