import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BottomTitle extends StatelessWidget {
  final String shopName;
  final String openTime;
  final String closeTime;
  final String locaion;
  final String description;
  const BottomTitle(
      {super.key,
      required this.shopName,
      required this.description,
      required this.openTime,
      required this.closeTime,
      required this.locaion});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      Column(
        children: [
          Text(
            shopName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 15.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.sp),
                child: Icon(
                  Icons.location_on,
                  size: 2.h,
                  color: const Color.fromARGB(146, 82, 78, 78),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              SizedBox(
                width: 90.w,
                child: Text(
                  locaion,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 10.sp,
                      color: const Color.fromARGB(146, 120, 117, 117)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About:",
                    style: TextStyle(
                      color: const Color.fromARGB(146, 120, 117, 117),
                      fontSize: 12.sp,
                    ),
                  ),
                  ExpandableText(description),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Time: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              Text(
                openTime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                "Close Time: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                closeTime,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}
