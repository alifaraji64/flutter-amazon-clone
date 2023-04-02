import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/GlobalVars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.delete(Uri.parse("$uri/removeFromCart"),
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
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
