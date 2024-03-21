import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_state/basic_state.dart';
import 'package:uniplanet_mobile/bloc/product/product_state/upload_product.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/status/product_status.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
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

  String status = ON_SALE; // Initial toggle state for "For Sale"
  String category = 'Mobiles';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    meetingLocationController.dispose();
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

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
          price: status == ON_SALE
              ? double.parse(
                  double.parse(priceController.text).toStringAsFixed(2))
              : 0,
          category: category,
          status: status,
          images: images));
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    var state = context.watch<ProductBloc>().state;

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUploadedState ||
            state is ProductImageUploadedState) {
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
              'Add Product',
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
                    images.isNotEmpty
                        ? CarouselSlider(
                            items: images.map(
                              (i) {
                                return Builder(
                                  builder: (BuildContext context) => Image.file(
                                    i,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                );
                              },
                            ).toList(),
                            options: CarouselOptions(
                              viewportFraction: 1,
                              height: 200,
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select up to five Product Images',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                              status = ON_SALE;
                            } else {
                              status = FREE_STOCK;
                            }
                            if (status == FREE_STOCK) {
                              priceController.clear();
                            }
                          });
                        },
                        isSelected: [status == ON_SALE, status == FREE_STOCK],
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: status == ON_SALE
                                  ? Colors.black
                                  : Colors.white,
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
                                  color: status == FREE_STOCK
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: status == FREE_STOCK
                                  ? Colors.black
                                  : Colors.white,
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
                                  color: status == FREE_STOCK
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: productNameController,
                      hintText: 'Product Name',
                      maxLength: 30,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: priceController,
                      hintText: 'Price',
                      enabled: status == ON_SALE,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true), // Set the keyboard type to number
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,9}')),
                      ],
                      prefixText: status == ON_SALE ? '\$' : '',
                      validatorEnabled: status != FREE_STOCK,
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: meetingLocationController,
                      hintText: 'where to meet',
                      maxLength: 30,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton(
                        value: category,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: productCategories.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            category = newVal!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet: isKeyboardVisible
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.fromLTRB(12, 15, 12, 40),
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
      ),
    );
  }
}
