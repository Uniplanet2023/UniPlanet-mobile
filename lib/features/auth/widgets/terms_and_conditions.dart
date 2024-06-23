import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/widgets/terms_and_policies.dart';

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
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'Terms and Conditions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndPolicies(),
                      ),
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
