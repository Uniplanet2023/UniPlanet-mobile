import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_button.dart';
import 'package:uniplanet/features/common/presentation/widgets/custom_textfield.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({
    required this.product,
    super.key,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController productNameController =
      TextEditingController(text: widget.product.name);
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.product.description);
  late final TextEditingController priceController =
      TextEditingController(text: widget.product.price.toString());
  late final TextEditingController meetingLocationController =
      TextEditingController(text: widget.product.location);

  final int maxImages = 10; // Set the maximum number of images allowed

  bool showCategoryToggles = true; // New variable to control visibility
  bool showCustomLocation = false;
  bool isUploading = false;
  String type = 'For Sale';
  bool isOpenToOffers = false;
  String category = 'Electronics & Appliances';
  String selectedCategory = 'Electronics & Appliances';
  List<File> images = [];

  late List<String> originalImages = [];
  final _editProductFormKey = GlobalKey<FormState>();
  int selectedIndex = 0; // Index of the selected category
  String selectedLocation = 'Custom';
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.product.category;
    type = widget.product.type;
    isOpenToOffers = widget.product.isNegotiable;
    originalImages = widget.product.images;
    // Add listener to productNameController

    if (widget.product.location != 'On Campus' &&
        widget.product.location != 'Off Campus') {
      selectedLocation = 'Custom';
      showCustomLocation = true;
    } else {
      selectedLocation = widget.product.location;
      showCustomLocation = false;
    }
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

  Widget imageContainer({File? image, String? originalImage}) {
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
            child: image == null
                ? CachedNetworkImage(
                    imageUrl: originalImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error))
                : Image.file(image, fit: BoxFit.cover),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            setState(() => image == null
                ? originalImages.remove(originalImage)
                : images.remove(image));
          },
        ),
      ],
    );
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

  void editProduct() {
    if (images.isEmpty && originalImages.isEmpty) {
      SnackbarGlobal.showSnackBar(
          'Please add at least one image and fill all fields.');
      return;
    }
    if (selectedLocation == 'Custom' &&
        meetingLocationController.text.isEmpty) {
      SnackbarGlobal.showSnackBar('Please enter a custom location');
      return;
    }
    if (_editProductFormKey.currentState!.validate()) {
      Product newProduct = Product(
        id: widget.product.id,
        name: productNameController.text,
        description: descriptionController.text,
        price: type != 'Free Items'
            ? double.parse(
                double.parse(priceController.text).toStringAsFixed(2))
            : 0,
        category: selectedCategory,
        status: 'On Sale',
        images: originalImages,
        location: selectedLocation == 'Custom'
            ? meetingLocationController.text
            : selectedLocation,
        seller: widget.product.seller,
        createdAt: widget.product.createdAt,
        updatedAt: widget.product.updatedAt,
        likes: widget.product.likes,
        numberOfChat: widget.product.numberOfChat,
        type: type,
        isNegotiable: isOpenToOffers,
      );
      context
          .read<OnSaleProductBloc>()
          .add(UpdateOnSaleProductEvent(product: newProduct));
      context.read<ProductBloc>().add(UpdateProductEvent(
            product: newProduct,
            images: images,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUpdatedState) {
          Navigator.pop(context);
          SnackbarGlobal.showSnackBar('Successfully updated');
        } else if (state is ProductUpdatingState) {
          isUploading = true;
          setState(() {});
        } else if (state is ProductUpdateFailedState) {
          Navigator.pop(context);
          SnackbarGlobal.showSnackBar('Failed to update product');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              'Edit Product',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: [
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
                                  Text(
                                    '${images.length}/10',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Displaying existing images
                          for (String image in originalImages)
                            imageContainer(originalImage: image),
                          for (File image in images)
                            imageContainer(image: image),
                        ],
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
                              selectedColor:
                                  Theme.of(context).colorScheme.tertiary,
                              color: Theme.of(context).colorScheme.tertiary,
                              borderWidth: 0,
                              selectedBorderColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              onPressed: (int index) {
                                setState(() {
                                  if (index == 0) {
                                    type = 'For Sale';
                                    priceController.clear();
                                  } else if (index == 1) {
                                    type = 'Free Item';
                                    priceController.clear();
                                  } else {
                                    type = 'Buying';
                                    priceController.clear();
                                  }
                                });
                              },
                              isSelected: [
                                type == 'For Sale',
                                type == 'Free Item',
                                type == 'Buying'
                              ],
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: type == 'For Sale'
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
                                    'For Sale',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: type == 'For Sale'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: type == 'Free Item'
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
                                    'Free Item',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: type == 'Free Item'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary),
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
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surface
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                originalImages = [];
                                images = [];
                              });
                            },
                            child: const Icon(Icons.switch_camera_outlined),
                          )
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
                    if (type != 'Free Item')
                      Column(
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
                            prefixText: '\$',
                            validatorEnabled: false,
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
                      child: isUploading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: 'Edit',
                              onTap: () {
                                editProduct();
                              },
                            ),
                    ),
                    const SizedBox(height: 10),
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
