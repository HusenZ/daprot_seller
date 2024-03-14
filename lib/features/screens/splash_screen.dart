import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
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
    return Future.delayed(const Duration(seconds: 6), () async {
      final preferences = await SharedPreferences.getInstance();
      final bool isAuthenticated =
          preferences.getBool('isAuthenticated') ?? false;
      print(
          "------------------preferences = ${preferences.getBool("isAuthenticated")}");
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      } else {
        Navigator.pushReplacementNamed(context, Routes.authRoute);
      }
    });
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
            colors: [ColorsManager.whiteColor, ColorsManager.secondaryColor],
            begin: Alignment(0.0, 0.0),
            end: Alignment(0.0, 1.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // LottieBuilder.asset(
                  //   LottieImages.logo,
                  //   width: double.infinity,
                  //   onLoaded: (composition) {
                  //     // The animation has loaded
                  //     setState(() {
                  //       _isAnimationPlaying = false; // Stop the animation
                  //     });
                  //   },
                  //   repeat: false,
                  //   reverse: false,
                  // ),
                  CopyRights(),
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
