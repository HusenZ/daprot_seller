import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({super.key, required this.route});
  final String route;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Lottie.asset(AppLottie.noNetwork),
          DelevatedButton(
            text: "Retry",
            onTap: () {
              ConnectivityHelper.clareStackPush(context, route);
            },
          ),
        ],
      ),
    );
  }
}
