import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/housing/presentation/screens/housing_detail_page.dart';

ExpansionPanelList chatExpansionPanelHousing(FetchedHousingPost state,
    BuildContext context, bool isExpanded, Function isExpandedCallback) {
  return ExpansionPanelList(
    expansionCallback: (int index, bool isExpanded) {
      isExpandedCallback(!isExpanded);
    },
    children: [
      ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(state.currentHousingPost.title),
          );
        },
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HousingDetailPage(
                            housing: state.currentHousingPost)));
              },
              child: CachedNetworkImage(
                imageUrl: state.currentHousingPost.images[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Adjust the size as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                '\$${state.currentHousingPost.monthlyPayment}',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.home_outlined),
              label: const Text('Housing Detail'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                    color: Theme.of(context).colorScheme.tertiaryContainer),
              ),
              onPressed: () {
                // Review Product
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HousingDetailPage(
                            housing: state.currentHousingPost)));
              },
            ),
          ],
        ),
        isExpanded: isExpanded,
      ),
    ],
  );
}
