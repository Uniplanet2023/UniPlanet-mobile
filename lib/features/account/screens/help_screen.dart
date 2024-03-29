import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/account/widgets/menu_section.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Material(
              elevation: 0.2,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  MenuSection(
                    title: 'Delete Account',
                    icon: Icons.delete_forever_outlined,
                    color: Colors.red,
                    ontap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Icon(
                              Icons.warning_amber,
                              color: Colors.red,
                              size: 50,
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Do you want really to delete your account? You will not be able to undo this action.',
                                  style:
                                      TextStyle(overflow: TextOverflow.visible),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
