import 'package:gozip_seller/config/constants/onboarding_content.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OnBoardingPageViewItem extends StatelessWidget {
  const OnBoardingPageViewItem({
    super.key,
    required this.height,
    required this.width,
    required this.i,
  });

  final double height;
  final double width;
  final int i;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          LottieBuilder.asset(
            contents[i].image,
            height: 45.h,
            width: 100.w,
            repeat: true,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            contents[i].title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 16.sp,
                  color: ColorsManager.primaryColor,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            contents[i].desc,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
