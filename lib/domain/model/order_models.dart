import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  delivered,
  cancelled,
}

class OrderModel {
  String orderId;
  String userId;
  String quantity;
  List<OrderItem> orderItems;
  String totalPrice;
  String orderStatus;
  String orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.orderItems,
    required this.totalPrice,
    required this.orderStatus,
    required this.quantity,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'orderId': orderId});
    result.addAll({'userId': userId});
    result.addAll({'orderItems': orderItems.map((x) => x.toMap()).toList()});
    result.addAll({'totalPrice': totalPrice});
    result.addAll({'orderStatus': orderStatus});
    result.addAll({'orderDate': orderDate});

    return result;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      orderItems: List<OrderItem>.from(
          map['orderItems']?.map((x) => OrderItem.fromMap(x))),
      totalPrice: map['totalPrice'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      orderDate: map['orderDate'] ?? '',
      quantity: map['quantity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  OrderModel.fromSnapshot(DocumentSnapshot snapshot)
      : orderId = snapshot['orderId'],
        userId = snapshot['userId'],
        orderItems = _convertToProductList(snapshot['orderItems']),
        totalPrice = snapshot['totalPrice'],
        orderStatus = snapshot['orderStatus'],
        quantity = snapshot['quantity'],
        orderDate = snapshot['orderDate'];

  static List<OrderItem> _convertToProductList(List<dynamic> products) {
    return products.map((product) => OrderItem.fromMap(product)).toList();
  }
}

class OrderItem {
  final String name;
  final String price;
  final String details;
  final List<dynamic> imageUrl;
  final String category;
  final String cpId;
  final String shopId;

  OrderItem(
      {required this.name,
      required this.price,
      required this.details,
      required this.imageUrl,
      required this.category,
      required this.cpId,
      required this.shopId});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'price': price});
    result.addAll({'details': details});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'category': category});
    result.addAll({'cpId': cpId});
    result.addAll({'shopId': shopId});

    return result;
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      details: map['details'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'],
      cpId: map['cpId'] ?? '',
      shopId: map['shopId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}
