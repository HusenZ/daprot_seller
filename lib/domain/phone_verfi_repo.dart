import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationApi {
  static Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("phone no is $phoneNumber");
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Sellers')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    bool exists = querySnapshot.docs.isNotEmpty;
    debugPrint("exists value is $exists");
    debugPrint("phone no value is $phoneNumber");

    return exists;
  }

  Future<bool> signInWithVerificationCode(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Error signing in with verification code: $e');
      return false;
    }
  }
}
