import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/upload/domain/entities/payment_intent.dart';
import 'package:uniplanet/features/upload/domain/usecases/create_payment_intent.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentIntent createPaymentIntent;
  PaymentBloc({required this.createPaymentIntent}) : super(PaymentInitial()) {
    on<CreatePaymentIntentEvent>((event, emit) async {
      await _onCreatePaymentIntent(event, emit);
    });
  }

  Future<void> _onCreatePaymentIntent(
      CreatePaymentIntentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final paymentIntent = await createPaymentIntent(
        adName: event.adName,
        advertiser: event.advertiser,
        amount: event.amount,
        images: event.images,
        type: event.type,
        description: event.description,
        link: event.link,
        city: event.city,
        address: event.address,
        location: event.location,
        streetAddress: event.stateAddress,
        zipCode: event.zipCode,
      );
      emit(PaymentSuccess(paymentIntent));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
