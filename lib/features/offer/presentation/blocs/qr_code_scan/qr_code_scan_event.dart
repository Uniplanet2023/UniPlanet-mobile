part of 'qr_code_scan_bloc.dart';

sealed class QrCodeScanEvent extends Equatable {
  const QrCodeScanEvent();

  @override
  List<Object> get props => [];
}

class QrCodeScanned extends QrCodeScanEvent {
  final String token;
  final String offerId;
  const QrCodeScanned({required this.token, required this.offerId});

  @override
  List<Object> get props => [token];
}

class QrCodeScanInit extends QrCodeScanEvent {}
