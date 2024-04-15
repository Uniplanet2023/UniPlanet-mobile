import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/bloc/search_history/search_history_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/product.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const GetHotProductsEvent());
    context.read<SearchHistoryBloc>().add(const GetSearchHistoryEvent());
  }

  final List<String> interests = [
    'tickets',
    'coat rack',
    'freecycle',
    'plates',
    'toyota highlander',
    'table top easel',
    'moncler',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Categories',
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 200,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Row(
                children: [
                  Text(
                    '🔥Hot items in Stony Brook University',
                    style: GoogleFonts.roboto(
                        fontSize: 15.sp, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.homePage,
                            arguments: 'Hot Products');
                      },
                      icon: Icon(Icons.arrow_forward_ios, size: 15.sp))
                ],
              ),
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is LoadingCategoryState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedCategoryState) {
                  return Container(
                    height: 150.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.hotProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildProductContent(state.hotProducts[index]);
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text('Browse by category',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            // Search bar here
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 9 / 10,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: GlobalVariables.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.homePage,
                        arguments: GlobalVariables.categories[index]['name']),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            color: Colors.grey[200],
                            width: 55.w,
                            height: 55.h,
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
            Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('Based on your interests',
                    style: Theme.of(context).textTheme.titleLarge)),
            // Interests section here
            // Interests section here
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 10
                        .w, // Space between individual chips on the same line.
                    runSpacing: 10.h, // Space between lines of chips.
                    children: state.searchHistory
                        .take(5)
                        .map((text) => GestureDetector(
                              onTap: () {
                                context
                                    .read<SearchProductBloc>()
                                    .add(SearchProductEvent(productName: text));
                                Navigator.pushNamed(
                                    context, AppRoutes.searchScreenPage);
                              },
                              child: Chip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Colors.black45, width: 1),
                                ),
                                labelPadding: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 0.h),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 15.sp,
                                      color: Colors.black54,
                                    ),
                                    Text(
                                      text,
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
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
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}

Widget buildProductContent(Product product) => Container(
      width: 140.w, // Set a fixed width for each card
      padding:
          EdgeInsets.symmetric(horizontal: 4.w), // Add some horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start

        children: [
          // Fixed size container for the image
          Container(
            height: 100.h, // Fixed height for the image
            width: double.infinity, // Take the full width of the container
            padding: EdgeInsets.all(8.w),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.w), // Rounded corners for the image
              child: CachedNetworkImage(
                imageUrl:
                    product.images[0], // Replace with your product image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product name
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              product.name, // Replace with your product name
              style: TextStyle(
                fontSize: 12.sp, // Use ScreenUtil for responsive font size
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Product price
          Padding(
            padding: EdgeInsets.only(
                bottom: 4.h), // Use ScreenUtil for responsive padding
            child: Text(
              '\$${product.price.toStringAsFixed(2)}', // Format the price to two decimal places
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
