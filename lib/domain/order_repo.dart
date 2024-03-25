import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
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
}
