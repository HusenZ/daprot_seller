import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class ReturnLabel extends StatelessWidget {
  const ReturnLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: 1.w),
      child: Text(
        " $label",
        style:
            TextStyle(fontWeight: FontWeightManager.semiBold, fontSize: 14.sp),
      ),
    );
  }
}
