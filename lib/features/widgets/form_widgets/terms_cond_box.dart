import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditionBox extends StatelessWidget {
  const TermsAndConditionBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        // width: 70.w,
        child: RichText(
          maxLines: 3,
          text: TextSpan(
            text: "I have accepted the ",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontSize: FontSize.s15.sp,
                ),
            children: <TextSpan>[
              TextSpan(
                  text: "Terms and Conditions",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ColorsManager.accentColor,
                        fontSize: FontSize.s15.sp,
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
