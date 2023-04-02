import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  final String name;
  final String description;
  final int quantity;
  final List<dynamic> images;
  final String category;
  final double price;
  final String? id;
  final List<Rating>? ratings;

  Product(
      {required this.name,
      required this.description,
      required this.quantity,
      required this.images,
      required this.category,
      required this.price,
      this.id,
      this.ratings});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'ratings': ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'] as String,
        description: map['description'] as String,
        quantity: map['quantity'] as int,
        images: List<dynamic>.from((map['images'] as List<dynamic>)),
        category: map['category'] as String,
        price: map['price'].toDouble() as double,
        id: map['_id'] != null ? map['_id'] as String : null,
        ratings: map['ratings'] != null
            ? List<Rating>.from((map['ratings'].map((x) => Rating.fromMap(x))))
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
