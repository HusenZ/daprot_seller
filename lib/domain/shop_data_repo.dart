import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getProductStream(String uid) {
    return _firestore
        .collection('Sellers')
        .doc(uid)
        .collection('Products')
        .snapshots();
  }

  Stream<QuerySnapshot> getShopStream(String uid) {
    return _firestore
        .collection('Sellers')
        .doc(uid)
        .collection('Applications')
        .snapshots();
  }
}
