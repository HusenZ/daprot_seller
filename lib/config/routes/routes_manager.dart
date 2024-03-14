import 'package:daprot_seller/features/screens/add_food_court_screens/form1_screen.dart';
import 'package:daprot_seller/features/screens/add_food_court_screens/form2_screen.dart';
import 'package:daprot_seller/features/screens/add_food_court_screens/form3_screen.dart';
import 'package:daprot_seller/features/screens/auth_screen/login_screen.dart';
import 'package:daprot_seller/features/screens/auth_screen/otp_screen.dart';
import 'package:daprot_seller/features/screens/auth_screen/set_profile_screen.dart';
import 'package:daprot_seller/features/screens/home_screen.dart';
import 'package:daprot_seller/features/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String authRoute = '/login';
  static const String otpRoute = '/otp';
  static const String otpLoginRoute = '/otpLogin';
  static const String setProfileRoute = '/profilePhoto';
  static const String homeRoute = '/home';
  static const String productRoute = '/product';
  static const String form1 = '/form1';
  static const String form2 = '/form2';
  static const String form3 = '/form3';
  static const String noInternetRoute = '/noInternet';
  static const String underReview = '/underReview';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.authRoute: (context) => const LoginScreen(),
    Routes.splashRoute: (context) => const SplashScreen(),
    Routes.otpRoute: (context) => const OtpScreen(),
    Routes.setProfileRoute: (context) => const SetProfileScreen(),
    Routes.homeRoute: (context) => const HomeScreen(),
    Routes.form1: (context) => const FCScreen1(),
    Routes.form2: (context) => const FCScreen2(),
    Routes.form3: (context) => const FCScreen3(),
    Routes.underReview: (context) => const UnderReview(),
  };
}

class UnderReview extends StatelessWidget {
  const UnderReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("under reivew"),
      ),
    );
  }
}
