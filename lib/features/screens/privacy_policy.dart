import 'package:daprot_seller/polycies/privacy_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.sp),
          child: SingleChildScrollView(
            child: RichText(
              text: const WidgetSpan(
                child: Text(
                  pPolicy,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
