import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/screens/home_screen.dart';
import 'package:daprot_seller/features/screens/under_reivew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigation();
  }

  Future<void> navigation() async {
    final preferences = await SharedPreferences.getInstance();
    final bool isAuthenticated =
        preferences.getBool('isAuthenticated') ?? false;
    print(
        "------------------preferences = ${preferences.getBool("isAuthenticated")}");
    if (isAuthenticated) {
      createAdminFuture().then((value) {
        if (value == ApplicationStatus.unverified) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UnderReivew()),
            (Route<dynamic> route) => false,
          );
        } else if (value == ApplicationStatus.verified) {
          ConnectivityHelper.replaceIfConnected(
            context,
            Routes.dashboard,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      });
    } else {
      ConnectivityHelper.replaceIfConnected(context, Routes.onboardingRoute);
    }
  }

  Future<ApplicationStatus> createAdminFuture() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return ApplicationStatus.noMatch;
    }

    final snapshot = await FirebaseFirestore.instance.collection('Admin').get();

    for (var doc in snapshot.docs) {
      if (doc.data()['clientId'] == userId) {
        final status = doc.data()['applicationStatus'];
        if (status == 'verified') {
          return ApplicationStatus.verified;
        } else {
          return ApplicationStatus.unverified;
        }
      }
    }

    return ApplicationStatus.noMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/applogo.png',
          fit: BoxFit.fill,
          height: 40.w,
          width: 40.w,
        ),
      ),
    );
  }
}

enum ApplicationStatus { verified, unverified, noMatch }
