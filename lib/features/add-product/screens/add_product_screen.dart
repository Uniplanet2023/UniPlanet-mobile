import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniket/bloc/account/account_bloc.dart';
import 'package:uniket/bloc/product/product_bloc.dart';
import 'package:uniket/common/routes/names.dart';
import 'package:uniket/common/widgets/custom_button.dart';
import 'package:uniket/common/widgets/custom_textfield.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/constants/utils.dart';
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

  bool showCategoryToggles = false; // New variable to control visibility

  bool freeStock = false;
  String category = 'Electronics & Appliances';
  String selectedCategory = 'Electronics & Appliances'; // Initial category
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

    if (_addProductFormKey.currentState!.validate()) {
      context.read<ProductBloc>().add(UploadProductEvent(
          productName: productNameController.text,
          description: descriptionController.text,
          price: !freeStock
              ? double.parse(
                  double.parse(priceController.text).toStringAsFixed(2))
              : 0,
          category: selectedCategory,
          status: 'On Sale',
          images: images,
          location: meetingLocationController.text,
          seller: context.read<AccountBloc>().state.account.user));
    }
  }

  void selectImages() async {
    // Your logic to pick more images and add to the list, make sure it does not exceed maxImages
    var res = await pickImages(); // Implement pickImages to return List<File>

    if ((images.length + res.length) <= maxImages) {
      setState(() {
        images.addAll(res); // Add new selected images to the existing list
      });
    } else {
      // Show some error message if maxImages limit is reached
      SnackbarGlobal.showSnackBar('You can only add up to $maxImages images.');
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
            border: Border.all(color: Colors.grey.shade300),
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
    // bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    var state = context.watch<ProductBloc>().state;

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUploadedState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.bottomBarPage, (route) => false);
        }
      },
      child: Scaffold(
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
              style: TextStyle(
                color: Colors.black,
              ),
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
                            onTap: selectImages,
                            child: Container(
                              width: 70,
                              height: 70,
                              margin:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: Colors.grey[600]),
                                  Text('${images.length}/10',
                                      style: TextStyle(
                                          color: Colors.grey[600],
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
                        selectedColor: Colors.white,
                        color: Colors.white,
                        borderWidth: 0,
                        selectedBorderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        onPressed: (int index) {
                          setState(() {
                            if (index == 0) {
                              freeStock = false;
                              priceController.clear();
                            } else {
                              freeStock = true;
                            }
                          });
                        },
                        isSelected: [freeStock, !freeStock],
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: !freeStock ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border:
                                  Border.all(width: 1, color: Colors.black45),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'For Sale',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      freeStock ? Colors.black : Colors.white),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: freeStock ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border:
                                  Border.all(width: 1, color: Colors.black45),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'Free',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      freeStock ? Colors.white : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      controller: productNameController,
                      hintText: 'Product Name',
                      maxLength: 30,
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
                    if (!freeStock)
                      CustomTextField(
                        controller: priceController,
                        hintText: 'Price',
                        enabled: !freeStock,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true), // Set the keyboard type to number
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,9}')),
                        ],
                        prefixText: !freeStock ? '\$' : '',
                        validatorEnabled: !freeStock,
                      ),

                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: meetingLocationController,
                      hintText: 'Enter custom meeting location',
                      maxLength: 30,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                    ),

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
