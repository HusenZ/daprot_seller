// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ShopFormRepo {
  static late String _cid;

  static late String _shId;
//step1 data;
  static late String shName;
  static late String brandlogoImage;
  static late String shLoacation;
  static late String opentime;
  static late String closetime;
  static late String description;
  static late bool delivery;
  static late String shPhone;
  static late double latitude1;
  static late double longitude1;
//step2 data
  static late String ownerName;
  static late String bannerImage;
  static late String ownerImg;
  static late String ownerPhoneNo;
  static late String ownerPanNo;
//step3 data
  static late bool conditionaccept;
  static late String gstImage;

  static location({required double latitude, required double longitude}) {
    latitude1 = latitude;
    longitude1 = longitude;
  }

  static Future<void> addForm1(
      {required String shNameIn,
      required XFile? shopLogo,
      required String location,
      required String phoneNo,
      required String openTime,
      required String closeTime,
      required bool isAvailable,
      required String shopDescription}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        throw Exception("User not authenticated");
      }

      if (shopLogo == null) {
        throw Exception("Shop logo not provided");
      }

      // Upload brand logo to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref('ShopLogos-images/${auth.currentUser!.uid}.jpg');
      await ref.putFile(File(shopLogo.path));

      brandlogoImage = await ref.getDownloadURL();

      // Get current user ID
      _cid = auth.currentUser!.uid;
      print(_cid);
      // Generate a unique ID for the 'shop' document
      _shId = const Uuid().v4();

      shName = shNameIn;
      shLoacation = location;
      shPhone = phoneNo;
      opentime = openTime;
      closetime = closeTime;
      delivery = isAvailable;
      description = shopDescription;

      debugPrint("step1 data added successfully ");
    } catch (e) {
      debugPrint("Error in the Step One${e.toString()}");
    }
  }

  static Future<void> addForm2({
    required String name,
    required XFile? shopBanner,
    required XFile? ownerphoto,
    required String phoneNo,
    required String panNo,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        throw Exception("User not authenticated");
      }

      if (shopBanner == null) {
        throw Exception("Shop logo not provided");
      }
      if (ownerphoto == null) {
        throw Exception("Shop logo not provided");
      }

      // Upload brand logo to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref('shop-banners/${auth.currentUser!.uid}.jpg');
      await ref.putFile(File(shopBanner.path));

      bannerImage = await ref.getDownloadURL();
      // Upload brand ownweimg to Firebase Storage
      Reference ref2 = FirebaseStorage.instance
          .ref('owner-images/${auth.currentUser!.uid}.jpg');
      await ref2.putFile(File(ownerphoto.path));

      ownerImg = await ref2.getDownloadURL();

      // Get current user ID
      _cid = auth.currentUser!.uid;
      ownerName = name;
      ownerPhoneNo = phoneNo;
      ownerPanNo = panNo;

      debugPrint("step2 data added successfully");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> addForm3({
    required bool coditionacceptance,
    required XFile? gstImg,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        throw Exception("User not authenticated");
      }

      if (gstImg == null) {
        throw Exception("Shop logo not provided");
      }

      // Upload leaseAgreement image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref('gst-images/${auth.currentUser!.uid}.jpg');
      await ref.putFile(File(gstImg.path));

      gstImage = await ref.getDownloadURL();

      // Get current user ID
      _cid = auth.currentUser!.uid;

      conditionaccept = coditionacceptance;
      //add details in Application  collection which is inside clients collection
      print("${shName}");
      await firestore.collection('Shops').doc(_cid).set({
        'type': 'shop',
        'cid': _cid,
        'id': _shId,
        'name': shName,
        'shopLogo': brandlogoImage,
        'location': shLoacation,
        'phoneNo': shPhone,
        'openTime': opentime,
        'closeTime': closetime,
        'dilivery': delivery,
        'shopImage': bannerImage,
        'conditionAcceptstatus': conditionaccept,
        'latitude': latitude1,
        'longitude': longitude1,
        'description': description,
        'applicationStatus': 'pending'
      });
      //create interest collection inside application collection

      debugPrint("owner details added into ownerdetails collection");
      await firestore.collection('Admin').doc(_shId).set({
        'clientId': _cid,
        'applicationId': _shId,
        'status': 'submited',
        'applicationStatus': 'pending',
      });

      debugPrint("application data added successfully into admin collection");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('SetStore', true);
      return Future.value(true);
    } catch (e) {
      debugPrint('Error in Creating the shop ---> ${e.toString()}');
      return Future.value(false);
    }
  }

  Future<void> updateShopData({
    XFile? shopLogo,
    XFile? shopImage,
    String? shName,
    String? phoneNumber,
    String? openTime,
    String? closeTime,
    bool? isParking,
    String? productDescrip,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final sid = FirebaseAuth.instance.currentUser!.uid;

    try {
      String? logoUrl;
      String? bannerUrl;
      final shopRef = firestore.collection('Shops').doc(sid);

      final updates = <String, dynamic>{};
      if (shopImage != null) {
        Reference ref = FirebaseStorage.instance.ref('shop-banners/$sid.jpg');
        await ref.putFile(File(shopImage.path));
        bannerUrl = await ref.getDownloadURL();
      }

      if (shopLogo != null) {
        Reference ref =
            FirebaseStorage.instance.ref('ShopLogos-images/$sid.jpg');
        await ref.putFile(File(shopLogo.path));

        logoUrl = await ref.getDownloadURL();
      }

      if (logoUrl != null) updates['shopLogo'] = logoUrl;
      if (bannerUrl != null) updates['shopImage'] = bannerUrl;
      if (shName != null) updates['name'] = shName;
      if (phoneNumber != null) updates['phoneNo'] = phoneNumber;
      if (openTime != null) updates['openTime'] = openTime;
      if (closeTime != null) updates['closeTime'] = closeTime;
      if (isParking != null) updates['isParking'] = isParking;
      if (productDescrip != null) updates['description'] = productDescrip;

      await shopRef.set(updates, SetOptions(merge: true));

      print('Shop data updated successfully!');
    } catch (e) {
      print('Error updating shop data: $e');
      rethrow; // Re-throw the exception to propagate it upwards
    }
  }
}
