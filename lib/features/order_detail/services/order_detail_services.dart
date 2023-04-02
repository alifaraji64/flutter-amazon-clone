import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants/GlobalVars.dart';
import '../../../constants/error_handling.dart';
import '../../../models/order.dart';

class OrderDetailServices {
  Future<Order> changeOrderStatus(
      {required BuildContext context,
      required Order order,
      required String type}) async {
    late Order resOrder;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res = await http.post(Uri.parse('$uri/changeOrderStatus'),
          headers: {
            'Content-Type': 'application/json',
            'auth-token': token,
          },
          body: jsonEncode({'orderId': order.id, 'type': type}));
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(jsonDecode(res.body));
          int status = jsonDecode(res.body)['status'];
          resOrder = order.copyWith(status: status);
          //print(orders);
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return resOrder;
  }
}
