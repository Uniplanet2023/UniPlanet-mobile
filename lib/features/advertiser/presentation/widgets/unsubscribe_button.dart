import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/advertisement/advertisement_bloc.dart';

class UnSubscribeButton extends StatelessWidget {
  final Advertisement advertisement;
  const UnSubscribeButton({
    super.key,
    required this.advertisement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle unsubscribe action
          getIt<MyAdvertisementBloc>()
              .add(CancelSubscriptionEvent(advertisementId: advertisement.id));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          minimumSize: const Size(double.infinity, 60),
          foregroundColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.2),
          elevation: 5,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Unsubscribe',
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
