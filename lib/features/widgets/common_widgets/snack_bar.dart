import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void customSnackBar(BuildContext context, String message, bool success) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    backgroundColor: success ? Colors.green : Colors.red,
    content: Row(
      children: [
        success
            ? Icon(
                Icons.gpp_good,
                size: 7.w,
              )
            : Icon(
                Icons.gpp_bad,
                size: 7.w,
              ),
        SizedBox(width: 5.w),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: success
                  ? ColorsManager.whiteColor
                  : ColorsManager.lightRedColor,
              fontSize: 15.sp),
        ),
      ],
    ),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
