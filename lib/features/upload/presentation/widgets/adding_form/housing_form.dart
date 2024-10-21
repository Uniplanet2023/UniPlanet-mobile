import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';
import 'package:uniplanet/features/upload/presentation/blocs/housing/housing_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_type_toggle.dart';
import 'package:uniplanet/features/upload/presentation/widgets/category_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/housing_detail.dart';
import 'package:uniplanet/features/upload/presentation/widgets/image_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/state_address.dart';

class HousingFormWidget extends StatefulWidget {
  final GlobalKey<FormState> addProductFormKey;

  final Function(String newType) setType;

  const HousingFormWidget({
    super.key,
    required this.addProductFormKey,
    required this.setType,
  });

  @override
  State<HousingFormWidget> createState() => _HousingFormWidgetState();
}

class _HousingFormWidgetState extends State<HousingFormWidget> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
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

  void postHousing() {
    if (images.isEmpty) {
      SnackbarGlobal.showSnackBar(
          'Please add at least one image and fill all fields.');
      return;
    }
    if (selectedLocation == 'Custom' &&
        (stateAddress == null ||
            city == null ||
            address == null ||
            zipCode == null)) {
      SnackbarGlobal.showSnackBar('Please enter a custom location');
      return;
    }
    if (isSecurityDeposit && securityDepositController.text.isEmpty) {
      SnackbarGlobal.showSnackBar('Please enter a security deposit');
      return;
    }
    if (priceController.text.isEmpty) {
      SnackbarGlobal.showSnackBar('Please enter a monthly payment');
      return;
    }
    if (widget.addProductFormKey.currentState!.validate()) {
      HousingPostForm housingPostForm = HousingPostForm(
        images: images,
        title: productNameController.text,
        monthlyPayment:
            double.parse(double.parse(priceController.text).toStringAsFixed(2)),
        isUtilityIncluded: isUtilityIncluded,
        securityDeposit: isSecurityDeposit
            ? double.parse(
                double.parse(securityDepositController.text).toStringAsFixed(2))
            : 0.0,
        gender: selectedGender,
        housingConditions: selectedHousingConditions,
        location: selectedLocation,
        stateAddress: stateAddress!,
        city: city!,
        address: address!,
        zipCode: zipCode!,
        category: selectedCategory,
        description: descriptionController.text,
        seller: getIt<AccountBloc>().state.account.user,
      );

      getIt<HousingBloc>()
          .add(UploadHousingPostEvent(housingPostForm: housingPostForm));
    }
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
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    securityDepositController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool isOpenToOffers = false;
  bool isUtilityIncluded = false;
  bool isSecurityDeposit = false;

  bool showCategoryToggles = false;

  String category = 'Increase Website Visits';
  String selectedCategory = 'Increase Website Visits';
  List<String> selectedHousingConditions = [];
  String selectedGender = 'N/A';

  @override
  Widget build(BuildContext context) {
    var state = context.watch<ProductBloc>().state;
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
          type: 'Housing',
          onTypeChanged: (newType) {
            widget.setType(newType);
            setState(() {
              maxImages = 10;
              selectedLocation = newType == 'Housing' ? 'Custom' : 'On Campus';
              showCustomLocation = newType == 'Housing';
              showLocationToggle = newType != 'Housing';
              priceController.clear();
              securityDepositController.clear();
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
                type: 'Housing',
                selectedCategory: selectedCategory,
                onCategoryChanged: (category) {
                  setState(() {
                    selectedCategory = category;
                    maxImages = 10;
                  });
                },
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        CustomTextField(
          controller: priceController,
          hintText: 'Monthly Payment',
          maxLength: 8,
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
          prefixText: '\$',
          validatorEnabled: true,
        ),
        const SizedBox(height: 10),
        HousingDetails(
          isUtilityIncluded: isUtilityIncluded,
          isSecurityDeposit: isSecurityDeposit,
          onUtilityChanged: (value) {
            setState(() => isUtilityIncluded = value);
          },
          onSecurityDepositChanged: (value) {
            setState(() => isSecurityDeposit = value);
          },
          securityDepositController: securityDepositController,
          selectedGender: selectedGender,
          onGenderChanged: (gender) {
            setState(() => selectedGender = gender);
          },
          selectedHousingConditions: selectedHousingConditions,
          onHousingConditionChanged: (condition, selected) {
            setState(() {
              if (selected) {
                selectedHousingConditions.add(condition);
              } else {
                selectedHousingConditions.remove(condition);
              }
            });
          },
        ),
        // Location fields
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
          controller: descriptionController,
          hintText: 'Description',
          maxLines: 7,
          maxLength: 3000,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 10),
        state is ProductUploadingState
            ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : BlocBuilder<HousingBloc, HousingState>(
                builder: (context, state) {
                  if (state is HousingPostUploading ||
                      state is HousingPostUploaded ||
                      state is HousingImagesUploaded) {
                    return ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                  return CustomButton(
                    text: 'Post',
                    onTap: () {
                      postHousing();
                    },
                  );
                },
              ),
        const SizedBox(height: 30),
      ],
    );
  }
}
