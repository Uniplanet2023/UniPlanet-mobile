import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/search_history/search_history_bloc.dart';
import 'package:uniplanet/common/routes/names.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/api/repository/index.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchHistoryBloc>().add(const GetSearchHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: GlobalVariables.backgroundColor,
          centerTitle: false,
          title: const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 0),
              height: 2, // Thickness of the line
              color: Colors.grey[200], // Color of the line
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '🔥Hot items in ',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '${AuthRepository.school}',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.category,
                            arguments: 'Hot Products');
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 15))
                ],
              ),
            ),
            BlocBuilder<HotProductBloc, HotProductState>(
              builder: (context, state) {
                if (state is LoadingHotProductState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedHotProductState ||
                    state is EndHotProductState) {
                  return Container(
                    height: 170,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.hotProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildProductContent(
                            context: context,
                            product: state.hotProducts[index]);
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2, // Thickness of the line
              color: Colors.grey[200], // Color of the line
            ),

            Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  '✨ Browse By Category',
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.secondaryColor),
                )),
            // Search bar here
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 10 / 10,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: GlobalVariables.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.category,
                        arguments: GlobalVariables.categories[index]['name']),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            color: Colors.grey[200],
                            width: 55,
                            height: 55,
                            child: Image.asset(
                                GlobalVariables.categories[index]['image'],
                                fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            GlobalVariables.categories[index]['name'],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 2, // Thickness of the line
              color: Colors.grey[200], // Color of the line
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: Text(
                  '🔍 Based on your interests',
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.secondaryColor),
                )),
            // Interests section here
            // Interests section here
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
                builder: (context, state) {
                  return Wrap(
                    spacing:
                        10, // Space between individual chips on the same line.
                    runSpacing: 10, // Space between lines of chips.
                    children: state.searchHistory
                        .take(5)
                        .map((text) => GestureDetector(
                              onTap: () {
                                context.read<SearchProductBloc>().add(
                                    LoadSearchProductEvent(productName: text));
                                Navigator.pushNamed(
                                    context, AppRoutes.searchScreenPage);
                              },
                              child: Chip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Colors.black45, width: 1),
                                ),
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 15,
                                      color: Colors.black54,
                                    ),
                                    Text(
                                      text,
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

Widget buildProductContent(
        {required BuildContext context, required Product product}) =>
    GestureDetector(
      onTap: () {
        context.read<ProductBloc>().add(IncreaseClickProductEvent(product.id));
        Navigator.pushNamed(
          context,
          AppRoutes.productDetailsPage,
          arguments: product,
        );
      },
      child: Container(
        width: 140, // Set a fixed width for each card
        padding: const EdgeInsets.symmetric(
            horizontal: 4), // Add some horizontal padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start

          children: [
            // Fixed size container for the image
            Container(
              height: 100, // Fixed height for the image
              width: double.infinity, // Take the full width of the container
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Rounded corners for the image
                child: product.images.isEmpty
                    ? const SizedBox()
                    : CachedNetworkImage(
                        imageUrl: product
                            .images[0], // Replace with your product image path
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Product name
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                product.name, // Replace with your product name
                style: const TextStyle(
                  fontSize: 12, // Use ScreenUtil for responsive font size
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Product price
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 4), // Use ScreenUtil for responsive padding
              child: Text(
                ' \$${product.price.toStringAsFixed(2)}', // Format the price to two decimal places
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
