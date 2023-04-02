import 'dart:convert';

import 'package:amazon_clone/constants/GlobalVars.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/user.dart';

class ProductDetailsServices {
  Future<void> addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse("$uri/addToCart"),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'id': product.id}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = Provider.of<UserProvider>(context, listen: false)
              .user
              .copyWith(cart: jsonDecode(res.body)['cart']);
          Provider.of<UserProvider>(context, listen: false).setUserModel(user);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green[600],
              content: const Text(
                'item added to cart',
                style: TextStyle(
                  color: Colors.white,
                ),
              )));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse("$uri/rateProduct"),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'id': product.id, 'rating': rating}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
