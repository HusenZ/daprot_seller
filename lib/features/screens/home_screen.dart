import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:daprot_seller/config/constants/app_images.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: SizedBox(
              width: 90.w,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Agne',
                    color: ColorsManager.primaryColor),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                        'Join the thriving world of intra-city e-commerce.'),
                  ],
                ),
              ),
            ),
          ),
          Image.asset(
            AppImages.enrolljpg,
          ),
          DelevatedButton(
            onTap: () {
              ConnectivityHelper.replaceIfConnected(context, Routes.form1);
            },
            text: "Become a Local Hero",
          ),
          // Padding(
          //   padding: EdgeInsets.all(8.sp),
          //   child: SizedBox(
          //     width: 90.w,
          //     height: 4.h,
          //     child: DefaultTextStyle(
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         color: ColorsManager.primaryColor,
          //       ),
          //       child: AnimatedTextKit(
          //         isRepeatingAnimation: true,
          //         animatedTexts: [
          //           WavyAnimatedText(
          //               'Together, let\'s build a vibrant network of'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(8.sp),
          //   child: SizedBox(
          //     width: 90.w,
          //     height: 4.h,
          //     child: DefaultTextStyle(
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         color: ColorsManager.primaryColor,
          //       ),
          //       child: AnimatedTextKit(
          //         isRepeatingAnimation: true,
          //         animatedTexts: [
          //           WavyAnimatedText('local businesses and happy customers. '),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
