import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_type_toggle.dart';
import 'package:uniplanet/features/upload/presentation/widgets/category_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/image_selection.dart';

class AdvertisementFormWidget extends StatefulWidget {
  final GlobalKey<FormState> addProductFormKey;

  final Function(String newType) setType;

  const AdvertisementFormWidget({
    super.key,
    required this.setType,
    required this.addProductFormKey,
  });

  @override
  State<AdvertisementFormWidget> createState() =>
      _AdvertisementFormWidgetState();
}

class _AdvertisementFormWidgetState extends State<AdvertisementFormWidget> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final bool showLinkField = true;
  bool showCategoryToggles = false;
  String selectedCategory = 'Increase Website Visits';
  String? stateAddress;
  String? city;
  String? address;
  String? zipCode;
  bool showLocationToggle = true;
  bool showCustomLocation = false;
  String selectedLocation = 'On Campus';
  int maxImages = 1;
  List<File> images = [];
  int selectedIndex = 0;

  void setAddress({
    required String state,
    required String city,
    required String address,
    required String zipCode,
  }) {
    setState(() {
      stateAddress = state;
      this.city = city;
      this.address = address;
      this.zipCode = zipCode;
    });
  }

  //onCategoryChanged is a function that takes a string as an argument and returns void
  void uploadAd({required String tier}) {
    getIt<PaymentBloc>().add(CreatePaymentIntentEvent(
      tier: tier,
      adName: productNameController.text,
      description: descriptionController.text,
      link: linkController.text,
      images: images,
      type: selectedCategory,
      advertiser: getIt<AccountBloc>().state.account.user,
      location: selectedLocation,
      stateAddress: stateAddress,
      city: city,
      address: address,
      zipCode: zipCode,
    ));
  }

  void onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      // maxImages = category == 'Get More messages' ? 10 : 1;
    });
  }

  @override
  void initState() {
    super.initState();
    productNameController.addListener(() {
      final bool shouldShowToggles = productNameController.text.isNotEmpty;
      if (showCategoryToggles != shouldShowToggles) {
        setState(() {
          showCategoryToggles = shouldShowToggles;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        ImageSelection(
          images: images,
          maxImages: maxImages,
          updateState: setState,
        ),
        const SizedBox(height: 30),
        AdvertisementTypeToggle(
          type: 'Advertisement',
          onTypeChanged: (newType) {
            widget.setType(newType);
            setState(() {
              maxImages = 10;
              selectedLocation = newType == 'Housing' ? 'Custom' : 'On Campus';
              showCustomLocation = newType == 'Housing';
              showLocationToggle = newType != 'Housing';
            });
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: productNameController,
          hintText: 'Title',
          maxLength: 100,
        ),
        showCategoryToggles
            ? CategorySelection(
                type: 'Advertisement',
                selectedCategory: selectedCategory,
                onCategoryChanged: onCategoryChanged,
              )
            : const SizedBox(),
        if (showLinkField)
          CustomTextField(
            controller: linkController,
            hintText: 'Link (https://example.com)',
            maxLines: 1,
            maxLength: 300,
            keyboardType: TextInputType.url,
            validatorEnabled: true,
          ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Next',
          onTap: () {
            if (images.isEmpty) {
              SnackbarGlobal.showSnackBar(
                  'Please add at least one image and fill all fields.');
              return;
            }
            if (selectedCategory == 'Get More messages' &&
                productNameController.text.isEmpty &&
                descriptionController.text.isNotEmpty) {
              SnackbarGlobal.showSnackBar(
                  'Please enter a title and description');
              return;
            } else if (selectedCategory == 'Get More messages' &&
                productNameController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              Navigator.pushNamed(
                context,
                AppRoutes.setBudgetPage,
                arguments: uploadAd,
              );
              return;
            }
            if (widget.addProductFormKey.currentState!.validate()) {
              Navigator.pushNamed(
                context,
                AppRoutes.setBudgetPage,
                arguments: uploadAd,
              );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
