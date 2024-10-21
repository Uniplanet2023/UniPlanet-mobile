import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/housing/presentation/widgets/housing_card.dart';

class HousingListPage extends StatefulWidget {
  const HousingListPage({super.key});

  @override
  State<HousingListPage> createState() => _HousingListPageState();
}

class _HousingListPageState extends State<HousingListPage> {
  @override
  void initState() {
    super.initState();
    getIt<GetHousingBloc>().add(FetchHousingPosts());

    // Call the method after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeVisit();
    });
  }

  // Method to check if it's the user's first time visiting the page
  Future<void> _checkFirstTimeVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeHousingVisit') ?? true;

    if (isFirstTime) {
      // If it's the first time, show the warning dialog
      _showWarningDialog();
      // Set the flag to false so the message won't appear again
      prefs.setBool('isFirstTimeHousingVisit', false);
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // Rounded corners for the dialog
          elevation: 12, // Add a shadow effect
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon to make the warning stand out visually
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Warning!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ],
                ),

                // Warning title

                const SizedBox(height: 15),
                // Warning content message
                Text(
                  'This feature exposes information to external users, who may not be students. Please exercise caution when interacting.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 25),
                // Divider to separate the content from the button
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                // Action buttons with modern styling
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Properties'),
      ),
      body: BlocBuilder<GetHousingBloc, GetHousingState>(
        builder: (context, state) {
          if (state is HousingPostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HousingPostsError) {
            return Center(child: Text(state.message));
          }
          if (state is HousingPostsLoaded) {
            return ListView.builder(
              itemCount: state.housingPosts.length,
              itemBuilder: (context, index) {
                return HousingPostCard(housing: state.housingPosts[index]);
              },
            );
          }
          return const SizedBox(
            height: 50,
          );
        },
      ),
    );
  }
}
