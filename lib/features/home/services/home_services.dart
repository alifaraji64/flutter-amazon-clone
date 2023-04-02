import 'dart:convert';

import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/GlobalVars.dart';
import '../../../constants/error_handling.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<Product>> getCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    List<Product> products = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse('$uri/getCategoryProducts'),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'category': category}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (var product in (jsonDecode(res.body))) {
              products.add(Product.fromJson(jsonEncode(product)));
            }
            print(products);
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return products;
  }

  Future<Product> dealOfDay({required BuildContext context}) async {
    late Product product;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.get(
        Uri.parse('$uri/dealOfDay'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token,
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(response: res, context: context, onSuccess: () {});
      product = Product.fromJson(res.body);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    print(product);
    return product;
  }
}
