import 'package:gozip_seller/config/routes/routes_manager.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/domain/connectivity_helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 235),
      body: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Text(
            'Take Your Business Online',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: ColorsManager.primaryColor),
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () {
              ConnectivityHelper.replaceIfConnected(context, Routes.form1);
            },
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Container(
                    height: 25.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                ),
                Positioned(
                  top: 2.h,
                  left: 7.w,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Container(
                      height: 15.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: ColorsManager.whiteColor,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 7.h,
                  left: 42.w,
                  child: Icon(
                    Icons.add,
                    color: ColorsManager.primaryColor,
                    size: 50.sp,
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 23.w,
                  right: 20.w,
                  child: Text(
                    "Create Your Shop",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: ColorsManager.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
