import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/auth/widgets/custom_button.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/GlobalVars.dart';
import '../../../models/user.dart';
import '../../search/screens/search_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: true).user;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to Buy (${user.cart.length} items)',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AddressScreen.routeName,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const SizedBox(height: 10),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: user.cart.length,
              itemBuilder: (context, index) {
                print(user.cart);
                var product = Product.fromMap(user.cart[index]['product']);
                return CartProduct(
                  product: product,
                  quantity: user.cart[index]['quantity'] as int,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
