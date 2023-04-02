import 'dart:convert';

import 'package:amazon_clone/features/address/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/GlobalVars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AddressServices {
  Future setAdress(
      {required BuildContext context, required String address}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse("$uri/setAddress"),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'address': address}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(jsonDecode(res.body));
          User user = Provider.of<UserProvider>(context, listen: false)
              .user
              .copyWith(address: jsonDecode(res.body)['address']);
          Provider.of<UserProvider>(context, listen: false).setUserModel(user);
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future pay({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse("$uri/paymentInvoice"),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({
            'subtotal':
                // ignore: use_build_context_synchronously
                Provider.of<UserProvider>(context, listen: false).subTotal
          }));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          String invoice = jsonDecode(res.body)['invoice'];
          Navigator.pushNamed(context, WebviewScreen.routeName,
              arguments: invoice);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
