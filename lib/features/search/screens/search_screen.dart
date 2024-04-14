import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet_mobile/bloc/search_history/search_history_bloc.dart';
import 'package:uniplanet_mobile/bloc/search_product/search_product_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/search/screens/search_result_screen.dart';
import 'package:uniplanet_mobile/features/search/widget/searched-product-list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];
  @override
  void initState() {
    super.initState();
    context.read<SearchHistoryBloc>().add(const GetSearchHistoryEvent());
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _deleteSearch(String search, int index) {
    context
        .read<SearchHistoryBloc>()
        .add(RemoveSearchHistoryEvent(query: search));
  }

  void _deleteAllSearches() {
    context.read<SearchHistoryBloc>().add(const ClearSearchHistoryEvent());
    setState(() {
      recentSearches.clear();
    });
  }

  void navigateToSearchScreen(String query) {
    if (query.isNotEmpty) {
      context
          .read<SearchProductBloc>()
          .add(SearchProductEvent(productName: query));
    } else if (query.isEmpty) {
      context.read<SearchProductBloc>().add(InitalSearchProductEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: true,
                        onFieldSubmitted: (query) =>
                            navigateToSearchScreen(query),
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {
                              context.read<SearchProductBloc>().add(
                                  SearchProductEvent(
                                      productName: _searchController.text));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search College Market',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
          builder: (context, state) {
            if (state is GettingSearchHistoryState) {
              return const Center(
                child: Loader(),
              );
            }
            if (state is GotSearchHistoryState ||
                state is RemovedSearchHistoryState ||
                state is ClearedSearchHistoryState ||
                state is RemovingSearchHistoryState ||
                state is ClearingSearchHistoryState) {
              recentSearches = state.searchHistory;
              return BlocBuilder<SearchProductBloc, SearchProductState>(
                builder: (context, state) {
                  if (state is SearchingProductState) {
                    return const Center(
                      child: Loader(),
                    );
                  }
                  if (state is SearchedProductState) {
                    if (state.productList.isEmpty) {
                      return const Center(
                          child: Text('No Search Results Found!'));
                    }

                    return SearchedProductList(products: state.productList);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 25, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Searches',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _deleteAllSearches,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: recentSearches.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => {
                                _searchController.text = recentSearches[index],
                                navigateToSearchScreen(recentSearches[index]),
                              },
                              child: ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(recentSearches[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _deleteSearch(
                                      recentSearches[index], index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: Text('No Search Results Found!'),
            );
          },
        ));
  }
}
