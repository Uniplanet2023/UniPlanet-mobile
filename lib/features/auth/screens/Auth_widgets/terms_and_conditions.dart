import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: RichText(
        text: TextSpan(
          text:
              'The person must agree to abide by the terms of services in order to continue: ',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'Terms and Conditions',
                style: const TextStyle(
                  color: GlobalVariables.secondaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Terms and Conditions'),
                          content: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Terms and Conditions Text goes here ...",
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Understood'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
