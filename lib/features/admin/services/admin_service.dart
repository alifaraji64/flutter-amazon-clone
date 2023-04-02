import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/constants/GlobalVars.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/error_handling.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';

class AdminService {
  Future<void> addProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required int quantity,
      required String category,
      required List<File> images}) async {
    try {
      final cloudinary = CloudinaryPublic('dr35hteyx', 'tevawrkl');
      List<String> imageUrls = [];
      for (var image in images) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            image.path,
            resourceType: CloudinaryResourceType.Image,
          ),
        );
        imageUrls.add(res.secureUrl);
        var product = Product(
          name: name,
          description: description,
          price: price,
          images: imageUrls,
          quantity: quantity,
          category: category,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('auth-token')!;
        http.Response response = await http.post(Uri.parse('$uri/addProduct'),
            headers: {
              'Content-Type': 'application/json',
              'auth-token': token,
            },
            body: product.toJson());
        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Product Added Successfully'),
            ));
            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.pop(context);
            });
          },
        );
      }
    } on CloudinaryException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<List<Product>> getProducts({required BuildContext context}) async {
    List<Product> products = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res =
          await http.get(Uri.parse('$uri/getProducts'), headers: {
        'Content-Type': 'application/json',
        'auth-token': token,
      });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (var product in (jsonDecode(res.body))) {
              //products.add(Product.fromJson(jsonEncode(product)));
              products.add(Product.fromJson(jsonEncode(product)));
            }
          });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return products;
  }

  Future<void> deleteProduct(
      {required BuildContext context, required String productId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response response = await http.post(
        Uri.parse('$uri/deleteProduct'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token,
        },
        body: jsonEncode({'id': productId}),
      );
      print(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<List<Order>> getOrders({required BuildContext context}) async {
    List<Order> orders = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth-token')!;
      http.Response res =
          await http.get(Uri.parse('$uri/getOrders/admin'), headers: {
        'Content-Type': 'application/json',
        'auth-token': token,
      });
      print(res.body);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(res.body);
          for (var order in jsonDecode(res.body)) {
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
