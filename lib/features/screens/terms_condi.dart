import 'package:daprot_seller/polycies/terms_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditoins extends StatelessWidget {
  const TermsAndConditoins({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: RichText(
              text: const WidgetSpan(
                child: Text(
                  termsConditions,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
