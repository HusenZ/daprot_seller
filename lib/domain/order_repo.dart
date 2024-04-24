import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/model/shipping_address.dart';
import 'package:daprot_seller/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String sellerId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('shopId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList());
  }

  Future<void> updateOrderStatus(
      {required String newStatus, required String orderId}) async {
    try {
      final CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('orders');

      // Query orders where shopId matches
      QuerySnapshot ordersSnapshot =
          await ordersCollection.where('orderId', isEqualTo: orderId).get();
      print("Order Id ---> $orderId");

      for (DocumentSnapshot doc in ordersSnapshot.docs) {
        await doc.reference.update({'orderStatus': newStatus});
      }

      print('Order status updated successfully.');
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
