import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'dart:io';

import 'package:uniplanet/features/upload/domain/entities/housing_post_form.dart';
import 'package:uniplanet/features/upload/presentation/blocs/bloc/housing_bloc.dart';
import 'package:uniplanet/features/upload/presentation/widgets/category_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/housing_detail.dart';
import 'package:uniplanet/features/upload/presentation/widgets/image_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/location_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/product_type_toggle.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  final TextEditingController meetingLocationController =
      TextEditingController();
  final int maxImages = 10; // Set the maximum number of images allowed
  bool isOpenToOffers = false;
  bool isUtilityIncluded = false;
  bool isSecurityDeposit = false;
  bool showLocationToggle = true;
  bool showCategoryToggles = false; // New variable to control visibility
  bool showCustomLocation = false;
  String type = 'For Sale';
  String category = 'Electronics & Appliances';
  String selectedCategory = 'Electronics & Appliances'; // Initial category
  String selectedLocation = 'On Campus';
  List<String> selectedHousingConditions = [];
  String selectedGender = 'N/A'; // Initial gender selection
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  int selectedIndex = 0; // Index of the selected category

  void selectImages(BuildContext context) async {
    var pickedImage = await pickImages(context);
    if ((images.length + pickedImage.length) <= maxImages) {
      images = [...images, ...pickedImage];
      setState(() => {});
    } else {
      SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
    }
  }

  void selectImageFromCamera(BuildContext context) async {
    File? image = await openCamera(context);
    if (image != null) {
      if (images.length + 1 <= maxImages) {
        // setState is required here in the original widget, not in this stateless widget.
        images.add(image);
        setState(() => {});
      } else {
        SnackbarGlobal.showSnackBar(
            'You can only add up to $maxImages images.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listener to productNameController
    productNameController.addListener(() {
      final bool shouldShowToggles = productNameController.text.isNotEmpty;
      // Update showCategoryToggles only if the value changes
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
    descriptionController.dispose();
    priceController.dispose();
    meetingLocationController.dispose();
    securityDepositController.dispose();
    super.dispose();
  }

  void sellProduct() {
    if (images.isEmpty) {
      SnackbarGlobal.showSnackBar(
          'Please add at least one image and fill all fields.');
      return;
    }
    if (selectedLocation == 'Custom' &&
        meetingLocationController.text.isEmpty) {
      SnackbarGlobal.showSnackBar('Please enter a custom location');
      return;
    }

    if (_addProductFormKey.currentState!.validate()) {
      getIt<ProductBloc>().add(UploadProductEvent(
        productName: productNameController.text,
        description: descriptionController.text,
        price: type == 'Free Item'
            ? 0
            : double.parse(
                double.parse(priceController.text).toStringAsFixed(2)),
        category: selectedCategory,
        status: 'On Sale',
        type: type,
        isNegotiable: isOpenToOffers,
        images: images,
        location: selectedLocation == 'Custom'
            ? meetingLocationController.text
            : selectedLocation,
        seller: getIt<AccountBloc>().state.account.user,
      ));
    }
  }

  void removeImage({required int selectedIndex}) {
    images.removeAt(selectedIndex);
    setState(() => {});
  }

  void postHousing() {
    if (images.isEmpty) {
      SnackbarGlobal.showSnackBar(
          'Please add at least one image and fill all fields.');
      return;
    }
    if (selectedLocation == 'Custom' &&
        meetingLocationController.text.isEmpty) {
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
    if (_addProductFormKey.currentState!.validate()) {
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
        location: meetingLocationController.text,
        category: selectedCategory,
        description: descriptionController.text,
        seller: getIt<AccountBloc>().state.account.user,
      );

      getIt<HousingBloc>()
          .add(UploadHousingPostEvent(housingPostForm: housingPostForm));
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<ProductBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductUploadedState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.bottomBarPage, (route) => false);
            }
          },
        ),
        BlocListener<HousingBloc, HousingState>(
          listener: (context, state) {
            if (state is HousingPostUploaded) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.bottomBarPage, (route) => false);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: const Text(
              'New listing',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _addProductFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ImageSelection(
                        images: images,
                        maxImages: maxImages,
                        selectImages: selectImages,
                        selectImageFromCamera: selectImageFromCamera,
                        removeImage: removeImage),
                    const SizedBox(height: 30),
                    ProductTypeToggle(
                      type: type,
                      onTypeChanged: (newType) {
                        setState(() {
                          type = newType;
                          selectedLocation =
                              newType == 'Housing' ? 'Custom' : 'On Campus';
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
                      hintText: 'Product Name',
                      maxLength: 100,
                    ),
                    if (showCategoryToggles)
                      CategorySelection(
                        type: type,
                        selectedCategory: selectedCategory,
                        onCategoryChanged: (category) {
                          setState(() => selectedCategory = category);
                        },
                      ),
                    const SizedBox(height: 10),
                    if (type != 'Free Item')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: priceController,
                            hintText:
                                type == 'Housing' ? "Monthly Payment" : 'Price',
                            enabled: true,
                            maxLength: 8,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            prefixText: type != 'Free Item' ? '\$' : '',
                            validatorEnabled: type != 'Free Item',
                          ),
                          const SizedBox(width: 10),
                          type == 'Housing'
                              ? HousingDetails(
                                  isUtilityIncluded: isUtilityIncluded,
                                  isSecurityDeposit: isSecurityDeposit,
                                  onUtilityChanged: (value) =>
                                      setState(() => isUtilityIncluded = value),
                                  onSecurityDepositChanged: (value) =>
                                      setState(() => isSecurityDeposit = value),
                                  securityDepositController:
                                      securityDepositController,
                                  selectedGender: selectedGender,
                                  onGenderChanged: (gender) =>
                                      setState(() => selectedGender = gender),
                                  selectedHousingConditions:
                                      selectedHousingConditions,
                                  onHousingConditionChanged:
                                      (condition, selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedHousingConditions
                                            .add(condition);
                                      } else {
                                        selectedHousingConditions
                                            .remove(condition);
                                      }
                                    });
                                  },
                                )
                              : Row(
                                  children: [
                                    Switch(
                                      value: isOpenToOffers,
                                      onChanged: (value) {
                                        setState(() {
                                          isOpenToOffers = value;
                                        });
                                      },
                                    ),
                                    const Text('Open to Offers'),
                                  ],
                                ),
                        ],
                      ),
                    if (showCustomLocation)
                      CustomTextField(
                        controller: meetingLocationController,
                        hintText: type == 'Housing'
                            ? 'Location'
                            : 'Enter custom meeting location',
                        maxLength: 60,
                      ),
                    if (showLocationToggle)
                      LocationSelection(
                        selectedLocation: selectedLocation,
                        onLocationChanged: (location) {
                          setState(() {
                            selectedLocation = location;
                            showCustomLocation = location == 'Custom';
                          });
                        },
                      ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7,
                      maxLength: 1000,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 10),
                    state is ProductUploadingState
                        ? ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        : CustomButton(
                            text: type == 'Housing' ? 'Post' : 'Sell',
                            onTap: () {
                              if (type == 'Housing') {
                                postHousing();
                              } else {
                                sellProduct();
                              }
                            },
                          ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
