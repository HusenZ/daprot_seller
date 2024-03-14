import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<bool> addUser({
    required XFile profile,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final uid = auth.currentUser!.uid;

      Reference ref = FirebaseStorage.instance.ref('user_profile/$uid.jpg');
      await ref.putFile(File(profile.path));
      String imgUrl = await ref.getDownloadURL();

      await _firestore.collection('Sellers').doc(uid).set({
        'userId': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'imgUrl': imgUrl,
      });
      print("User added to Firebase");

      // Return true to indicate success
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user: $e');
      }

      // Return false to indicate failure
      return false;
    }
  }
}
