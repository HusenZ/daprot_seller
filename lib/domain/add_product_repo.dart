import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Uuid _uuid = const Uuid();

  Future<String> addProduct(Product product) async {
    print("-------Entedred-------");
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      List<String> imageUrls = [];

      // Upload images to Firebase Storage
      for (XFile image in product.photos) {
        Reference ref = FirebaseStorage.instance
            .ref('product-images/$uid/${_uuid.v4()}.jpg');
        await ref.putFile(File(image.path));
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      String productId = _uuid.v4();
      await _firestore
          .collection('Sellers')
          .doc(uid)
          .collection('Products')
          .add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'discountedPrice': product.discountedPrice,
        'category': product.category,
        'selectedPhotos': imageUrls,
      });
      await _firestore.collection('Products').add({
        'shopId': uid,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'discountedPrice': product.discountedPrice,
        'category': product.category,
        'selectedPhotos': imageUrls,
      });

      print('Product added successfully');
      return 'Product added successfully';
    } catch (e) {
      print('Error adding product: $e');
      return 'Error adding product: $e';
    }
  }
}
