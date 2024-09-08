import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      print("Success ---------------");
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error in google sign is :----- ${e.message}");
      return false;
    } catch (e) {
      print('Error in google sign in ------> $e');
      return false;
    }
  }

  static Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final uid = auth.currentUser!.uid;

      await _firestore.collection('Sellers').doc(uid).set({
        'userId': uid,
        'name': name,
        'email': email,
        'phone': phone,
      });
      print("User added to Firebase");

      // Return true to indicate success
      preferences.setBool('isAuthenticated', true);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user: $e');
      }

      // Return false to indicate failure
      return false;
    }
  }

  static Future<bool> addUserEmailPass({
    required XFile profile,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: '1er3t4y5u67');
      if (_auth.currentUser == null) {
        print("Uesr is null");
        return false;
      } else {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          final uid = auth.currentUser!.uid;

          Reference ref =
              FirebaseStorage.instance.ref('seller_profile/$uid.jpg');
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
          preferences.setBool('isAuthenticated', true);
          return true;
        } catch (e) {
          if (kDebugMode) {
            print('Error adding user: $e');
          }

          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('---------The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('-------The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
