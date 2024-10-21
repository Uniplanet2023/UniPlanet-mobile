import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/offer/domain/usecases/validate_qr_token_usecase.dart';

part 'qr_code_scan_event.dart';
part 'qr_code_scan_state.dart';

class QrCodeScanBloc extends Bloc<QrCodeScanEvent, QrCodeScanState> {
  final ValidateQRTokenUseCase validateQRTokenUseCase;

  QrCodeScanBloc({required this.validateQRTokenUseCase})
      : super(QrCodeScanInitial()) {
    // Use on<> to handle QrCodeScanned event
    on<QrCodeScanned>(_onQrCodeScanned);
    on<QrCodeScanInit>(_onQrCodeScanInitial);
  }
  _onQrCodeScanInitial(
    QrCodeScanInit event,
    Emitter<QrCodeScanState> emit,
  ) {
    emit(QrCodeScanInitial());
  }

  // Event handler for QrCodeScanned event
  Future<void> _onQrCodeScanned(
    QrCodeScanned event,
    Emitter<QrCodeScanState> emit,
  ) async {
    emit(QrCodeScanLoading());
    try {
      final isValid = await validateQRTokenUseCase.call(
          token: event.token, offerId: event.offerId);
      if (isValid) {
        emit(const QrCodeScanSuccess("QR Code is valid!"));
      } else {
        emit(const QrCodeScanFailure("Invalid QR Code"));
      }
    } catch (e) {
      emit(const QrCodeScanFailure("Failed to validate QR Code"));
    }
  }
}
