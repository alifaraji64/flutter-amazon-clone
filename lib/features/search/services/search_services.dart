import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants/GlobalVars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/product.dart';

class SearchServices {
  Future<List<Product>> getSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> products = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse('$uri/getSearchedProducts'),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'searchQuery': searchQuery}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (var product in (jsonDecode(res.body))) {
              //products.add(Product.fromJson(jsonEncode(product)));
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
}
