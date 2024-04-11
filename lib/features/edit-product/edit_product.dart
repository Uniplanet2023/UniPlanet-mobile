import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet_mobile/common/widgets/custom_button.dart';
import 'package:uniplanet_mobile/common/widgets/custom_textfield.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';

class EditProductScreen extends StatefulWidget {
  final String? productId;
  final String? productName;
  final double? productPrice;
  final List<String>? productImages;
  final String? productCategory;
  final String? selectedLocation;
  final String? productDescription;
  const EditProductScreen({
    this.productId,
    this.productName,
    this.productPrice,
    this.productImages,
    this.productCategory,
    this.selectedLocation,
    this.productDescription,
    super.key,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController productNameController =
      TextEditingController(text: widget.productName);
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.productDescription);
  late final TextEditingController priceController =
      TextEditingController(text: widget.productPrice.toString());
  late final TextEditingController meetingLocationController =
      TextEditingController(text: widget.selectedLocation);
  late bool freeStock = widget.productPrice == 0 ? true : false;
  late String category = widget.productCategory!;
  int currentIndex = 0;
  // String selectedLocation = 'On Campus';
  List<File> images = [];
  late List<String>? orignalImages = widget.productImages;
  final _editProductFormKey = GlobalKey<FormState>();

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

  CarouselSlider _buildCarouselSlider() {
    return CarouselSlider(
      items: widget.productImages!
          .asMap()
          .entries
          .map((entry) => Builder(
                builder: (BuildContext context) {
                  String image = entry.value; // Access image URL
                  return CachedNetworkImage(
                    cacheManager: GlobalVariables.customCacheManager,
                    imageUrl: image,
                    fit: BoxFit.fill,
                    height: 400,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.red, size: 80),
                  );
                },
              ))
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 400,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: GlobalVariables.secondaryColor,
            ),
          ),
          title: const Text(
            'Edit Product',
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
            key: _editProductFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  orignalImages!.isNotEmpty
                      ? Column(
                          children: [
                            _buildCarouselSlider(),
                            Center(
                              child: DotsIndicator(
                                dotsCount: widget.productImages!.length,
                                position: currentIndex,
                              ),
                            ),
                          ],
                        )
                      : images.isEmpty
                          ? GestureDetector(
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
                            )
                          : CarouselSlider(
                              items: images.map(
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 400,
                              ),
                            ),

                  const SizedBox(height: 30),
                  // Toggle Buttons
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  color:
                                      !freeStock ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 1, color: Colors.black45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                child: Text(
                                  'For Sale',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: freeStock
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      freeStock ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 1, color: Colors.black45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                child: Text(
                                  'Free',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: freeStock
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              orignalImages = [];
                              images = [];
                            });
                          },
                          child: const Icon(Icons.switch_camera_outlined),
                        )
                      ],
                    ),
                  ),
                  CustomTextField(
                    controller: productNameController,
                    hintText: 'Product Name',
                    maxLength: 30,
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
                      validatorEnabled: freeStock,
                    ),
                  const SizedBox(height: 15),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: DropdownButton<String>(
                      value: category,
                      underline: const SizedBox(),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: productCategories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          category = newValue!;
                        });
                      },
                    ),
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

                  const SizedBox(
                    height: 130,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.fromLTRB(12, 15, 12, 40),
        child: CustomButton(
          text: 'Edit',
          onTap: () {
            print(productNameController.text);
            print(descriptionController.text);
            print(priceController.text);
            print(meetingLocationController.text);
          },
        ),
      ),
    );
  }
}
