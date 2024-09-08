import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gozip_seller/features/screens/no_network.dart';
import 'package:gozip_seller/features/widgets/common_widgets/snack_bar.dart';
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
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoNetwork(route: route),
      ));
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
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoNetwork(route: route),
      ));
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

  static Future<void> clareStackPush(BuildContext context, String route,
      {Object? args}) async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult != ConnectivityResult.none) {
      Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NoNetwork(route: route),
          ),
          (route) => false);
    }
  }
}
