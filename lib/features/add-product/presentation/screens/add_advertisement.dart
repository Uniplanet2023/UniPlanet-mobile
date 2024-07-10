import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/account/account_bloc.dart';
import 'package:uniplanet/features/common/presentation/product/product_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController meetingLocationController =
      TextEditingController();

  final int maxImages = 10; // Set the maximum number of images allowed
  bool isOpenToOffers = false;
  bool showCategoryToggles = false; // New variable to control visibility
  bool showCustomLocation = false;
  String type = 'Listing';
  String category = 'Electronics & Appliances';
  String selectedCategory = 'Electronics & Appliances'; // Initial category
  String selectedLocation = 'On Campus';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  int selectedIndex = 0; // Index of the selected category
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
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    meetingLocationController.dispose();
  }

  void sellProduct(BuildContext context) {
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
      context.read<ProductBloc>().add(UploadProductEvent(
          productName: productNameController.text,
          description: descriptionController.text,
          price: type == 'Advertisement'
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
          seller: context.read<AccountBloc>().state.account.user));
    }
  }

  void selectImages() async {
    // Your logic to pick more images and add to the list, make sure it does not exceed maxImages
    var res =
        await pickImages(context); // Implement pickImages to return List<File>

    if ((images.length + res.length) <= maxImages) {
      setState(() {
        images.addAll(res); // Add new selected images to the existing list
      });
    } else {
      // Show some error message if maxImages limit is reached
      SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
    }
  }

  void selectImageFromCamera() async {
    File? image = await openCamera(context);
    if (image != null) {
      if (images.length + 1 <= maxImages) {
        setState(() {
          images.add(image);
        });
      } else {
        SnackbarGlobal.showSnackBar(
            'You can only add up to $maxImages images.');
      }
    }
  }

  Widget imageContainer(File image) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.secondaryFixedDim),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(image, fit: BoxFit.cover),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            setState(() => images.remove(image));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<ProductBloc>().state;

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUploadedState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.bottomBarPage, (route) => false);
        }
      },
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: [
                          // Camera icon container to add new images
                          InkWell(
                            onTap: selectImageFromCamera,
                            child: Container(
                              width: 70,
                              height: 70,
                              margin:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryFixedDim),
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    size: 20,
                                  ),
                                  Text('${images.length}/10',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: selectImages,
                            child: Container(
                              width: 70,
                              height: 70,
                              margin:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryFixedDim),
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    size: 20,
                                  ),
                                  Text('${images.length}/10',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          // Displaying existing images
                          for (File image in images) imageContainer(image),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    // Toggle Buttons
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ToggleButtons(
                        borderColor: Colors.transparent,
                        fillColor: Colors.transparent,
                        selectedColor: Theme.of(context).colorScheme.tertiary,
                        color: Theme.of(context).colorScheme.tertiary,
                        borderWidth: 0,
                        selectedBorderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        onPressed: (int index) {
                          setState(() {
                            if (index == 0) {
                              type = 'Listing';
                              priceController.clear();
                            } else if (index == 1) {
                              type = 'Advertisement';
                              priceController.clear();
                            }
                          });
                        },
                        isSelected: [
                          type == 'Listing',
                          type == 'Advertisement',
                          type == 'Buying'
                        ],
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: type == 'Listing'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryFixedDim),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'Listing',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: type == 'Listing'
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: type == 'Advertisement'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryFixedDim),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'Advertisement',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: type == 'Advertisement'
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: type == 'Buying'
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryFixedDim),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'Wanted to buy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: type == 'Buying'
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: productNameController,
                      hintText: 'Product Name',
                      maxLength: 100,
                    ),
                    if (showCategoryToggles)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: GlobalVariables.categories
                              .map((category) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: ChoiceChip(
                                      selectedColor: Theme.of(context)
                                          .colorScheme
                                          .primaryFixedDim,
                                      label: Text(category['name']),
                                      selected:
                                          selectedCategory == category['name'],
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() => selectedCategory =
                                              category['name']);
                                        }
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (type != 'Advertisement')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: priceController,
                            hintText: 'Price',
                            enabled: true,
                            maxLength: 5,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false,
                                decimal:
                                    true), // Set the keyboard type to number
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,9}')),
                            ],
                            prefixText: type != 'Advertisement' ? '\$' : '',
                            validatorEnabled: type != 'Advertisement',
                          ),
                          Row(
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

                    const SizedBox(height: 10),
                    if (showCustomLocation)
                      CustomTextField(
                        controller: meetingLocationController,
                        hintText: 'Enter custom meeting location',
                        maxLength: 30,
                      ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: GlobalVariables.locations
                            .map((location) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ChoiceChip(
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim,
                                    label: Text(location),
                                    selected: selectedLocation == location,
                                    onSelected: (selected) {
                                      if (selected) {
                                        if (location == 'Custom') {
                                          showCustomLocation = true;
                                        } else {
                                          showCustomLocation = false;
                                        }
                                        selectedLocation = location;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7,
                      maxLength: 800,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 10),

                    Container(
                      child: (state is ProductUploadingState)
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
                              ))
                          : CustomButton(
                              text: 'Sell',
                              onTap: () => sellProduct(context),
                            ),
                    ),
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
