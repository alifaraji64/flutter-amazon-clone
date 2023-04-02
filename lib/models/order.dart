// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime orderedAt;
  final String userId;
  final double subTotal;
  final int status;
  final String address;
  final List<int> quantity;

  Order(
      {required this.id,
      required this.products,
      required this.orderedAt,
      required this.userId,
      required this.subTotal,
      required this.status,
      required this.address,
      required this.quantity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'orderedAt': orderedAt,
      'userId': userId,
      'subTotal': subTotal,
      'status': status,
      'address': address,
      'quantity': quantity
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      products: List<Product>.from(
        (map['products'] as List<dynamic>).map<Product>(
          (x) => Product.fromMap(x['product'] as Map<String, dynamic>),
        ),
      ),
      orderedAt: DateTime.parse(map['orderedAt']),
      userId: map['userId'] as String,
      subTotal: double.parse(map['subTotal'].toString()),
      status: int.parse(map['status'].toString()),
      address: map['address'] as String,
      quantity: List<int>.from(
        (map['products'] as List<dynamic>).map<int>(
          (x) => x['quantity'],
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  Order copyWith({
    String? id,
    List<Product>? products,
    DateTime? orderedAt,
    String? userId,
    double? subTotal,
    int? status,
    String? address,
    List<int>? quantity,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      orderedAt: orderedAt ?? this.orderedAt,
      userId: userId ?? this.userId,
      subTotal: subTotal ?? this.subTotal,
      status: status ?? this.status,
      address: address ?? this.address,
      quantity: quantity ?? this.quantity,
    );
  }
}
