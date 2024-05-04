import 'package:daprot_seller/features/screens/add_new_product.dart';
import 'package:daprot_seller/features/screens/forms/form1_screen.dart';
import 'package:daprot_seller/features/screens/forms/form2_screen.dart';
import 'package:daprot_seller/features/screens/forms/form3_screen.dart';
import 'package:daprot_seller/features/screens/auth_screen/login_screen.dart';
import 'package:daprot_seller/features/screens/auth_screen/set_profile_screen.dart';
import 'package:daprot_seller/features/screens/home_screen.dart';
import 'package:daprot_seller/features/screens/onboarding_screen.dart';
import 'package:daprot_seller/features/screens/privacy_policy.dart';
import 'package:daprot_seller/features/screens/shop_dashboard.dart';
import 'package:daprot_seller/features/screens/splash_screen.dart';
import 'package:daprot_seller/features/screens/terms_condi.dart';
import 'package:daprot_seller/features/screens/under_reivew.dart';
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
  static const String underReview = '/underReview';
  static const String dashboard = '/dashboard';
  static const String updateShop = '/updateShop';
  static const String addNewProduct = '/addNewProduct';
  static const String privacyRoute = '/privacy';
  static const String termsRoute = '/terms';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.authRoute: (context) => const LoginScreen(),
    Routes.splashRoute: (context) => const SplashScreen(),
    Routes.setProfileRoute: (context) => const SetProfileScreen(),
    Routes.homeRoute: (context) => const HomeScreen(),
    Routes.form1: (context) => const FCScreen1(),
    Routes.form2: (context) => const FCScreen2(),
    Routes.form3: (context) => const FCScreen3(),
    Routes.underReview: (context) => const UnderReivew(),
    Routes.dashboard: (context) => const ShopDashboard(),
    Routes.addNewProduct: (context) => const AddNewProdcut(),
    Routes.onboardingRoute: (context) => const OnboardingScreen(),
    Routes.privacyRoute: (context) => const PrivacyPolicy(),
    Routes.termsRoute: (context) => const TermsAndConditoins(),
  };
}
