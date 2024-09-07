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
import 'package:uniplanet/features/upload/presentation/blocs/housing/housing_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';
import 'package:uniplanet/features/upload/presentation/widgets/advertisement_type_toggle.dart';
import 'package:uniplanet/features/upload/presentation/widgets/category_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/housing_detail.dart';
import 'package:uniplanet/features/upload/presentation/widgets/image_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/location_selection.dart';
import 'package:uniplanet/features/upload/presentation/widgets/state_address.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  String? stateAddress;
  String? city;
  String? address;
  String? zipCode;

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

  int maxImages = 1;
  bool isOpenToOffers = false;
  bool isUtilityIncluded = false;
  bool isSecurityDeposit = false;
  bool showLocationToggle = true;
  bool showCategoryToggles = false;
  bool showCustomLocation = false;
  String type = 'Advertisement';
  String category = 'Increase Website Visits';
  String selectedCategory = 'Increase Website Visits';
  String selectedLocation = 'On Campus';
  List<String> selectedHousingConditions = [];
  String selectedGender = 'N/A';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  int selectedIndex = 0;

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
    descriptionController.dispose();
    priceController.dispose();
    securityDepositController.dispose();
    super.dispose();
  }

  void uploadAd({required double totalPayment}) {
    getIt<PaymentBloc>().add(CreatePaymentIntentEvent(
      amount: totalPayment,
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
  Widget build(BuildContext context) {
    var state = context.watch<ProductBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductUploadedState) {
              Navigator.pop(context, AppRoutes.bottomBarPage);
            }
          },
        ),
        BlocListener<HousingBloc, HousingState>(
          listener: (context, state) {
            if (state is HousingPostUploaded) {
              Navigator.pop(context, AppRoutes.bottomBarPage);
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
                    AdvertisementTypeToggle(
                      type: type,
                      onTypeChanged: (newType) {
                        setState(() {
                          type = newType;
                          type == 'Advertisement'
                              ? maxImages = 1
                              : maxImages = 10;
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
                      hintText: 'Title',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        type == 'Advertisement'
                            ? const SizedBox()
                            : CustomTextField(
                                controller: priceController,
                                hintText: type == 'Housing'
                                    ? 'Monthly Payment'
                                    : 'Price',
                                enabled: true,
                                maxLength: 8,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: false, decimal: true),
                                prefixText: '\$',
                                validatorEnabled: true,
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
                                      selectedHousingConditions.add(condition);
                                    } else {
                                      selectedHousingConditions
                                          .remove(condition);
                                    }
                                  });
                                },
                              )
                            : type == 'Advertisement'
                                ? const SizedBox()
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
                    if (type == 'Advertisement')
                      CustomTextField(
                        controller: linkController,
                        hintText: 'Link (https://example.com)',
                        maxLines: 1,
                        maxLength: 100,
                        keyboardType: TextInputType.url,
                        validatorEnabled: true,
                      ),
                    if (showCustomLocation && type != 'Advertisement')
                      GestureDetector(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StateSelectionPage(
                                      rootFrom: AppRoutes.addProductPage,
                                      setAddress: setAddress,
                                    ),
                                  ),
                                )
                              },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
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
                          )),
                    if (showLocationToggle && type != 'Advertisement')
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
                    if (type == 'Advertisement' &&
                            selectedCategory == 'Get More messages' ||
                        type != 'Advertisement')
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
                            text: type == 'Housing' ? 'Post' : 'Next',
                            onTap: () {
                              if (type == 'Housing') {
                                postHousing();
                              } else if (type == 'Advertisement') {
                                if (images.isEmpty) {
                                  SnackbarGlobal.showSnackBar(
                                      'Please add at least one image and fill all fields.');
                                  return;
                                }
                                if (_addProductFormKey.currentState!
                                    .validate()) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.setBudgetPage,
                                    arguments: uploadAd,
                                  );
                                }
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
