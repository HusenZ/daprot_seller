import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.transparentColor,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppLottie.productUploading,
                  width: 90.w,
                  height: 60.w,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 15.h,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      decorationStyle: TextDecorationStyle.dotted,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsManager.offWhiteColor,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(seconds: 3),
                      animatedTexts: [
                        RotateAnimatedText('Preparing Your Product...'),
                        RotateAnimatedText('Uploading Product Information...'),
                        RotateAnimatedText(
                            'Almost There! Finalizing Upload...'),
                      ],
                      onTap: () {
                        debugPrint("Tap Event");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
          child: CircularProgressIndicator(
        color: ColorsManager.primaryColor,
      )),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
