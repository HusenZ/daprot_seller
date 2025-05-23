import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Uuid _uuid = const Uuid();

  Future<String> addProduct(Product product) async {
    print("-------Entedred-------");
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      List<String> imageUrls = [];
      DocumentSnapshot<Map<String, dynamic>> locationDoc =
          await _firestore.collection('Shops').doc(uid).get();
      String location = locationDoc['location'];
      print("---> Prouduct Location --------> $location");
      // Upload images to Firebase Storage after compression
      if (product.photos != null) {
        for (XFile image in product.photos!) {
          // Compress image
          List<int>? compressedImageData =
              await FlutterImageCompress.compressWithFile(
            image.path,
            minHeight: 1920,
            minWidth: 1080,
            quality: 85,
          );

          if (compressedImageData != null) {
            // Create a temporary file to store compressed image
            File compressedImageFile = File(image.path);
            await compressedImageFile.writeAsBytes(compressedImageData);

            // Upload compressed image to Firebase Storage
            Reference ref = FirebaseStorage.instance
                .ref('product-images/$uid/${_uuid.v4()}.jpg');
            await ref.putFile(compressedImageFile);
            String url = await ref.getDownloadURL();
            imageUrls.add(url);

            // Delete temporary compressed image file
            await compressedImageFile.delete();
          }
        }
      }

      String productId = _uuid.v4();

      await _firestore.collection('Products').add({
        'productId': productId,
        'shopId': uid,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'discountedPrice': product.discountedPrice,
        'category': product.category,
        'selectedPhotos': imageUrls,
        'location': location,
      });

      print('Product added successfully');
      return 'Product added successfully';
    } catch (e) {
      print('Error adding product: $e');
      return 'Error adding product: $e';
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection('Products')
          .where('productId', isEqualTo: productId)
          .get()
          .then(
        (value) {
          for (var element in value.docs) {
            _firestore.collection('Products').doc(element.id).delete().then(
              (value) {
                return Future.value(true);
              },
            );
          }
        },
      );
      return Future.value(true);
    } catch (e) {
      print("Error in Deleteing produc ------> $e");
      return Future.value(false);
    }
  }

  Future<String> updateProduct(Product product, ProductFromDB originalProduct,
      List<dynamic> images) async {
    try {
      print("Entered int the update fucntion");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('productId', isEqualTo: originalProduct.productId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs.first.reference;

        await docRef.update({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'discountedPrice': product.discountedPrice,
          'category': product.category,
          'selectedPhotos': images,
        });

        print('Product updated successfully');
        return 'Product updated successfully';
      } else {
        // Document not found
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error updating product: $e');
      return 'Error updating product: $e';
    }
  }
}
