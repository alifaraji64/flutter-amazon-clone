import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/product_detail/services/product_details_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';

class CartProduct extends StatefulWidget {
  final Product product;
  final int quantity;
  const CartProduct({super.key, required this.product, required this.quantity});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  ProductDetailsServices productDetailsServices = ProductDetailsServices();
  CartServices cartServices = CartServices();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                widget.product.images[0],
                fit: BoxFit.fitWidth,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      "\$${widget.product.price}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text("Eligible for FREE Shipping"),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text(
                      "In Stock",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          color: Colors.black12,
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove,
                              size: 18,
                            ),
                            onPressed: () async {
                              await cartServices.removeFromCart(
                                context: context,
                                product: widget.product,
                              );
                              // ignore: use_build_context_synchronously
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCartSubtotal();
                            },
                          ),
                        ),
                        Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(widget.quantity.toString()),
                        ),
                        Container(
                          width: 35,
                          height: 32,
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                            ),
                            onPressed: () async {
                              await productDetailsServices.addToCart(
                                  context: context, product: widget.product);
                              // ignore: use_build_context_synchronously
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCartSubtotal();
                              print(Provider.of<UserProvider>(context,
                                      listen: false)
                                  .subTotal);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]))
      ],
    );
  }
}
