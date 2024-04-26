import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class Product {
  final String name;
  final String description;
  final String price;
  final String discountedPrice;
  final String category;
  final String subCategory;
  final List<XFile>? photos;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.subCategory,
    required this.photos,
    required this.category,
  });
}

class ProductFromDB {
  final String name;
  final String description;
  final String price;
  final String discountedPrice;
  final String subCategory;

  final List<dynamic> photos;
  final String productId;
  final String category;

  ProductFromDB(
      {required this.name,
      required this.description,
      required this.price,
      required this.discountedPrice,
      required this.subCategory,
      required this.productId,
      required this.category,
      required this.photos});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'subCategory': subCategory});
    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'price': price});
    result.addAll({'productId': productId});
    result.addAll({'discountedPrice': discountedPrice});
    result.addAll({'category': category});
    result.addAll({'photos': photos});

    return result;
  }

  factory ProductFromDB.fromMap(Map<String, dynamic> map) {
    return ProductFromDB(
      name: map['name'] ?? '',
      subCategory: map['subCategory'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      discountedPrice: map['discountedPrice'] ?? '',
      photos: List<String>.from(map['photos']),
      productId: map['productId'] ?? '',
      category: map['category'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductFromDB.fromJson(String source) =>
      ProductFromDB.fromMap(json.decode(source));
}
