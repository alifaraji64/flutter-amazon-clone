import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/product_detail/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/services/search_services.dart';
import 'package:amazon_clone/features/search/widgets/searched_product.dart';
import 'package:flutter/material.dart';

import '../../../constants/GlobalVars.dart';
import '../../../models/product.dart';
import '../../account/widgets/single_product.dart';

final SearchServices searchService = SearchServices();

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Product>> getProducts() async {
    return await searchService.getSearchedProducts(
      context: context,
      searchQuery: widget.searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVars.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(7),
                        child: TextFormField(
                          onFieldSubmitted: (query) {
                            Navigator.pushNamed(context, SearchScreen.routeName,
                                arguments: query);
                          },
                          cursorColor: Colors.black38,
                          decoration: const InputDecoration(
                            hintText: 'Search product',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                                // borderRadius: BorderRadius.all(
                                //   Radius.circular(7),
                                // ),
                                borderSide: BorderSide(color: Colors.black38)),
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.mic_outlined),
                    )
                  ]),
                )
              ],
            ),
          )),
      body: FutureBuilder(
          future: getProducts(),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(child: Text('unhadled exception'));
              }
              return Column(
                children: [
                  const AddressBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final Product product = snapshot.data![index];
                          return Column(
                            //children: [Text(snapshot['name'].toString())],
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ProductDetailScreen.routeName,
                                      arguments: product);
                                },
                                child: SearchedProduct(
                                  product: product,
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                ],
              );
            }
            return const Center(
              child: Center(child: Text('unhadled exception')),
            );
          }),
    );
  }
}
