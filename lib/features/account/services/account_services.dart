import 'dart:convert';

import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/GlobalVars.dart';

class AccountServices {
  Future<List<Order>> getOrders({required BuildContext context}) async {
    List<Order> orders = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(
        Uri.parse("$uri/getOrders/me"),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token,
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(res.body);
          for (var order in jsonDecode(res.body)) {
            //orders.add(Order.fromMap(order));
            print(order);
            print(Order.fromMap(order).quantity);
            orders.add(Order.fromMap(order));
          }
          //print(orders);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return orders;
  }
}
