import 'package:amazon_clone/features/auth/widgets/custom_button.dart';
import 'package:amazon_clone/features/product_detail/services/product_details_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/widgets/stars.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../constants/GlobalVars.dart';
import '../../../models/product.dart';
import '../../search/screens/search_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailsServices productDetailsServices = ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    // TODO: implement initState
    widget.product.ratings!.forEach((rating) {
      avgRating += rating.rating;
      if (rating.userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = rating.rating;
      }
    });
    if (widget.product.ratings!.length > 1) {
      avgRating = avgRating / widget.product.ratings!.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
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
                      child: Icon(Icons.notifications),
                    )
                  ]),
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.id!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Stars(rating: avgRating)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            CarouselSlider(
              items: widget.product.images.map((i) {
                return Builder(
                    builder: (BuildContext context) => Image.network(
                          i,
                          fit: BoxFit.cover,
                          height: 200,
                        ));
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                      text: 'Deal Price: ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                        text: '\$${widget.product.price.toString()}',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.description,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomButton(text: 'Buy Now', onPressed: () {}),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomButton(
                text: 'Add to Card',
                onPressed: () {
                  productDetailsServices.addToCart(
                    context: context,
                    product: widget.product,
                  );
                },
                color: Colors.amber,
                textColor: Colors.black,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Rate the Product',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            RatingBar.builder(
                initialRating: myRating,
                minRating: 1,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: GlobalVars.secondaryColor,
                    ),
                onRatingUpdate: (rating) {
                  productDetailsServices.rateProduct(
                    context: context,
                    product: widget.product,
                    rating: rating,
                  );
                })
          ],
        ),
      ),
    );
  }
}
