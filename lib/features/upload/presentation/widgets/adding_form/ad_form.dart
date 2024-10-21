import 'package:flutter/material.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_form.dart';
import 'package:uniplanet/features/upload/presentation/widgets/adding_form/housing_form.dart';
import 'package:uniplanet/features/upload/presentation/widgets/adding_form/job_form.dart';
import 'package:uniplanet/features/upload/presentation/widgets/adding_form/offer_form.dart';

class AdFormWidget extends StatefulWidget {
  final GlobalKey<FormState> addProductFormKey;

  const AdFormWidget({
    super.key,
    required this.addProductFormKey,
  });

  @override
  State<AdFormWidget> createState() => _AdFormWidgetState();
}

class _AdFormWidgetState extends State<AdFormWidget> {
  String type = 'Advertisement';
  void setType(String newType) {
    setState(() {
      type = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show different forms based on type
        if (type == 'Housing')
          HousingFormWidget(
            setType: setType,
            addProductFormKey: widget.addProductFormKey,
          )
        else if (type == 'Advertisement')
          AdvertisementFormWidget(
            setType: setType,
            addProductFormKey: widget.addProductFormKey,
          )
        else if (type == 'Job')
          JobPostForm(
            setType: setType,
          )
        else if (type == 'Offer')
          OfferForm(
            addProductFormKey: widget.addProductFormKey,
            setType: setType,
          )
      ],
    );
  }
}
