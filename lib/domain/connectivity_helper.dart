import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectivityHelper {
  static Future<void> replaceIfConnected(BuildContext context, String route,
      {Object? args}) async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult != ConnectivityResult.none) {
      // If connected, navigate to the specified route
      Navigator.of(context).pushReplacementNamed(route, arguments: args);
    } else {
      // If not connected, show the no internet screen
      Navigator.of(context).pushNamed(Routes.noInternetRoute);
    }
  }

  static Future<void> naviagte(BuildContext context, String route,
      {Object? args}) async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult != ConnectivityResult.none) {
      // If connected, navigate to the specified route
      Navigator.of(context).pushNamed(route, arguments: args);
    } else {
      // If not connected, show the no internet screen
      Navigator.of(context).pushNamed(Routes.noInternetRoute);
    }
  }

  static Future<void> popIfConnected(BuildContext context) async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult != ConnectivityResult.none) {
      // If connected, navigate to the specified route
      Navigator.of(context).pop();
    } else {
      // If not connected, show the no internet screen
      customSnackBar(
        context,
        'Check your Internet connection',
        false,
      );
    }
  }
}
