import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void customSnackBar(BuildContext context, String message, bool success) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    backgroundColor: success ? ColorsManager.secondaryColor : Colors.red,
    content: Row(
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.whiteColor,
                  fontSize: 12.sp,
                ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
