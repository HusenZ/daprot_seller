import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip_seller/domain/model/order_models.dart';
import 'package:gozip_seller/domain/model/shipping_address.dart';
import 'package:gozip_seller/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String sellerId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .orderBy('orderDate', descending: false)
        .where('shopId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList());
  }

  static Future<bool> sendFcmMessage(
      String title, String message, String? userToken) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAMVCKqmI:APA91bGVWUfB8ixjD0S17O1g_f20vwmDjjvI4yRymNvOKmAVajqjQEox4UfFzYefq3o31fnt9k5ujyqA-SV8PNb5FWvvcNhe67vKa0Npa6FN2MSXHG8_yIZSimf3UWNrrQgU6G1n_j7r",
      };
      var request = {
        "notification": {
          "title": title,
          "body": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": "$userToken",
      };

      var response = await http.post(Uri.parse(url),
          headers: header, body: json.encode(request));

      print(response.body);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateOrderStatus(
      {required String newStatus,
      required String orderId,
      required String userId}) async {
    try {
      String? message;
      if (newStatus == OrderStatus.cancelled.name) {
        message = 'Order has been cancelled';
      }
      if (newStatus == OrderStatus.delivered.name) {
        message = 'Order has been delivered, Please do review the product';
      }
      final CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('orders');

      // Query orders where shopId matches
      QuerySnapshot ordersSnapshot =
          await ordersCollection.where('orderId', isEqualTo: orderId).get();

      for (DocumentSnapshot doc in ordersSnapshot.docs) {
        await doc.reference.update({'orderStatus': newStatus});
      }
      final tokendoc = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('fcmToken')
          .doc('fcmdoc')
          .get();
      String? userToken = tokendoc['token'];
      await sendFcmMessage('${message ?? 'Status Update'} - $newStatus',
          "Delivery Status Updated", userToken);
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Stream<UserModel> streamUser(String uid) {
    if (uid.isEmpty) {
      return Stream.value(UserModel(
          name: 'fullName',
          email: 'email@example.com',
          phNo: 'phoneNumber',
          imgUrl:
              'https://th.bing.com/th/id/OIP.-MJ8HCqPBzqddQrWrY2dCQHaHa?w=512&h=512&rs=1&pid=ImgDetMain',
          uid: '0'));
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        return UserModel.fromMap({
          "name": data['name'],
          "userId": data['userid'],
          "imgUrl": data['imgUrl'],
          "phone": data['phone'],
          "email": data['email'],
        });
      } else {
        return UserModel(
            name: 'fullName',
            email: 'email@example.com',
            phNo: 'phoneNumber',
            imgUrl:
                'https://th.bing.com/th/id/OIP.-MJ8HCqPBzqddQrWrY2dCQHaHa?w=512&h=512&rs=1&pid=ImgDetMain',
            uid: '0');
      }
    });
  }

  Stream<Shipping> streamShippingAddress(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('ShippingAddress')
        .snapshots()
        .map((snapshot) {
      return Shipping.fromMap(snapshot.docs.first.data());
    });
  }

  // Stream for counting orders with pending status
  Stream<int> streamPendingOrdersCount() {
    return _firestore
        .collection('orders')
        .where('shopId', isEqualTo: sellerId)
        .where('orderStatus', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream for counting orders with delivered status
  Stream<int> streamDeliveredOrdersCount() {
    return _firestore
        .collection('orders')
        .where('shopId', isEqualTo: sellerId)
        .where('orderStatus', isEqualTo: 'delivered')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
