import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/constants/app_images.dart';
import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/screens/home_screen.dart';
import 'package:daprot_seller/features/screens/under_reivew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
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

  Future navigation() {
    return Future.delayed(const Duration(seconds: 3), () async {
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
    });
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
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.whiteColor,
              Color.fromARGB(237, 75, 182, 232)
            ],
            begin: Alignment(0.0, 0.0),
            end: Alignment(0.0, 1.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(AppImages.daprotLogin),
                  const CopyRights(),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Lottie.asset(
                    AppLottie.splashScreenBottom,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CopyRights extends StatelessWidget {
  const CopyRights({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 4.5.sp),
        child: const Text(
          '© 2024 DAPROT, Inc.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
  }
}

enum ApplicationStatus { verified, unverified, noMatch }
