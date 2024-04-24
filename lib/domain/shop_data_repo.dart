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

  Stream<List<QuerySnapshot<Map<String, dynamic>>>> getProductReviewsStream() {
    return _firestore
        .collection('Products')
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .asyncMap((productSnapshot) {
      List<String> productIds =
          productSnapshot.docs.map((doc) => doc.id).toList();
      return Future.wait(productIds.map((productId) {
        return _firestore
            .collection('Products')
            .doc(productId)
            .collection('Reviews')
            .get();
      }));
    }).asBroadcastStream();
  }

  Stream<QuerySnapshot> getShopStream(String uid) {
    return _firestore
        .collection('Shops')
        .where('cid', isEqualTo: shopId)
        .snapshots();
  }

  Future<QuerySnapshot> getShopFuture(String uid) {
    return _firestore.collection('Shops').where('cid', isEqualTo: shopId).get();
  }
}
