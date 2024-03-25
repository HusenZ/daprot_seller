import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String shopId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getProductStream(String uid) {
    return _firestore
        .collection('Products')
        .where('shopId', isEqualTo: shopId)
        .snapshots();
  }

  Stream<QuerySnapshot> getShopStream(String uid) {
    return _firestore
        .collection('Shops')
        .where('cid', isEqualTo: shopId)
        .snapshots();
  }
}
