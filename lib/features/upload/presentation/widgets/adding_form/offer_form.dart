import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/validate_url.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/features/upload/domain/entities/offer.dart';
import 'package:uniplanet/features/upload/presentation/blocs/offer/offer_bloc.dart';
import 'package:uniplanet/features/upload/presentation/screens/offer_category_page.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_type_toggle.dart';
import 'package:uniplanet/features/upload/presentation/widgets/image_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/state_address.dart';

class OfferForm extends StatefulWidget {
  final GlobalKey<FormState> addProductFormKey;

  final Function(String newType) setType;

  const OfferForm({
    super.key,
    required this.setType,
    required this.addProductFormKey,
  });

  @override
  State<OfferForm> createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController conditionsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final bool showLinkField = true;
  String? selectedCategory; // For selected industry
  String? stateAddress;
  String? city;
  String? address;
  String? zipCode;
  bool showLocationToggle = true;
  bool showCustomLocation = false;
  String selectedLocation = 'On Campus';
  int maxImages = 10;
  List<File> images = [];
  int selectedIndex = 0;
  // Function to show an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  // Validation logic
  bool _validateForm() {
    if (productNameController.text.isEmpty) {
      _showError('Please enter a voucher');
      return false;
    }
    if (stateAddress == null ||
        city == null ||
        address == null ||
        zipCode == null) {
      _showError('Please enter a address');
      return false;
    }
    if (linkController.text.isNotEmpty && !validateUrl(linkController.text)) {
      _showError('Please enter a valid link');
      return false;
    }
    if (images.isEmpty) {
      _showError('Please select an image');
      return false;
    }
    return true;
  }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfferBloc, OfferState>(
      listener: (context, state) {
        if (state is OfferPostSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer posted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Column(
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
            type: 'Offer',
            onTypeChanged: (newType) {
              widget.setType(newType);
              setState(() {
                maxImages = 10;
                selectedLocation = 'Custom';
                showCustomLocation = false;
                showLocationToggle = true;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: productNameController,
            hintText: 'Voucher',
            maxLength: 500,
            maxLines: 3,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectServiceCategory(),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedCategory = result; // Update selected job industry
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory ?? 'Select Category',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // handle custom location selection
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StateSelectionPage(
                  rootFrom: AppRoutes.addProductPage,
                  setAddress: (
                      {required String state,
                      required String city,
                      required String address,
                      required String zipCode}) {
                    setState(() {
                      stateAddress = state;
                      this.city = city;
                      this.address = address;
                      this.zipCode = zipCode;
                    });
                  },
                );
              }));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      city == null
                          ? 'Address'
                          : '$address, $city, $stateAddress, $zipCode',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: linkController,
            hintText: 'Link (https://example.com)',
            maxLines: 1,
            maxLength: 300,
            keyboardType: TextInputType.url,
            validatorEnabled: true,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            hintText: 'Phone Number (Optional)',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: conditionsController,
            hintText: 'Conditions (Optional)',
            maxLines: 7,
            maxLength: 3000,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: descriptionController,
            hintText: 'Notice (Optional)',
            maxLines: 7,
            maxLength: 3000,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),
          BlocBuilder<OfferBloc, OfferState>(
            builder: (context, state) {
              if (state is OfferPostInProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              return CustomButton(
                  text: 'Post',
                  onTap: () {
                    if (_validateForm()) {
                      final offer = Offer(
                        companyName:
                            getIt<AccountBloc>().state.account.user.name,
                        companyImage: getIt<AccountBloc>()
                            .state
                            .account
                            .user
                            .profileImage!,
                        voucher: productNameController.text,
                        description: descriptionController.text,
                        conditions: conditionsController.text,
                        phoneNumber: _phoneController.text,
                        stateAddress: stateAddress,
                        city: city,
                        address: address,
                        zipCode: zipCode,
                        link: linkController.text,
                        images: images,
                      );
                      //validate and post offer

                      getIt<OfferBloc>().add(PostOffer(offer: offer));
                    }
                  });
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
