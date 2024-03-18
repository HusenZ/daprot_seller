import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToggleButton extends StatelessWidget {
  final String back;
  final String next;
  final Function()? onPressedBack;
  final Function()? onPressedNext;

  const ToggleButton({
    super.key,
    required this.back,
    required this.next,
    required this.onPressedBack,
    required this.onPressedNext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        width: 85.w,
        height: 5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: ColorsManager.primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onPressedBack,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(back),
              ),
            ),
            InkWell(
              onTap: onPressedNext,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 45.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorsManager.primaryColor),
                  child: Center(
                    child: Text(
                      next,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: ColorsManager.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
