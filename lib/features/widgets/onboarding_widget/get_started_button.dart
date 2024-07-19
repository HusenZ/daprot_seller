import 'package:gozip_seller/config/routes/routes_manager.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/domain/connectivity_helper.dart';
import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: DelevatedButton(
        onTap: () {
          ConnectivityHelper.replaceIfConnected(context, Routes.authRoute);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: ColorsManager.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: (width <= 550)
              ? const EdgeInsets.symmetric(horizontal: 80, vertical: 17)
              : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
                fontSize: 14.sp,
              ),
        ),
        text: 'Get Started',
      ),
    );
  }
}
