import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: DelevatedButton(
        onTap: () {
          ConnectivityHelper.replaceIfConnected(context, Routes.form1);
        },
        text: "Enroll as shop",
      )),
    );
  }
}
