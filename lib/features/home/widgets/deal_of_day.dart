import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_detail/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  HomeServices homeServices = HomeServices();
  Future<Product> getDealOfDay() async {
    return await homeServices.dealOfDay(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDealOfDay(),
        builder: (context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text('unhadled exception'));
            }
            print(snapshot.data);
            return Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: const Text(
                    'Deal of the day',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: snapshot.data);
                  },
                  child: Image.network(
                    snapshot.data!.images[0],
                    height: 205,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 5,
                    right: 40,
                  ),
                  child: Text(
                    '\$ ${snapshot.data!.price.toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 5,
                    right: 40,
                  ),
                  child: Text(
                    snapshot.data!.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: snapshot.data!.images.map((e) {
                      return Image.network(
                        e,
                        fit: BoxFit.fitWidth,
                        width: 100,
                        height: 100,
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15)
                      .copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'See all deals',
                    style: TextStyle(color: Colors.cyan[800]),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: Center(child: Text('unhadled exception')),
          );
        });
  }
}
