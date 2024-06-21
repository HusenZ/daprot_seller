import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DsingleChildCard extends StatelessWidget {
  const DsingleChildCard({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 90.w,
      decoration: BoxDecoration(
          color: Color.fromARGB(34, 146, 75, 232),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 7.w,
                  height: 7.w,
                  child: CircleAvatar(
                    backgroundColor: ColorsManager.transparentColor,
                    child: Image.asset(image),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(title),
              ],
            ),
            const Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
}
