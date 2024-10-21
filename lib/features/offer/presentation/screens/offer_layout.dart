import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/offer/presentation/blocs/offer/offer_bloc.dart';
import 'package:uniplanet/features/offer/presentation/widgets/restuarant_card.dart';

class OfferListScreen extends StatefulWidget {
  const OfferListScreen({super.key});

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  @override
  void initState() {
    super.initState();
    getIt<GetOfferBloc>().add(const GetOffersEvent(page: 1, limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "All Conditions",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GetOfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OfferError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is OfferLoaded) {
            final offers = state.offers;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return RestaurantCard(offer: offers[index]);
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
