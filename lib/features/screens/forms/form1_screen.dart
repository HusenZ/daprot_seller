import 'package:gozip_seller/config/routes/routes_manager.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/config/theme/fonts_manager.dart';
import 'package:gozip_seller/domain/connectivity_helper.dart';
import 'package:gozip_seller/domain/shop_form_repo.dart';
import 'package:gozip_seller/domain/time_picker.dart';
import 'package:gozip_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:gozip_seller/features/widgets/common_widgets/i_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:gozip_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip_seller/features/widgets/common_widgets/profile_photo_widget.dart';
import 'package:gozip_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:gozip_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/form_widgets/input_location.dart';

class FCScreen1 extends StatefulWidget {
  const FCScreen1({super.key});

  @override
  State<FCScreen1> createState() => _FCScreen1State();
}

class _FCScreen1State extends State<FCScreen1> {
  /// FORM KEY
  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();
  bool _dilivery = false;

  /// CONTROLLERS

  TextEditingController shNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  // TextEditingController phoneNoController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController procutDescripController = TextEditingController();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  String? openTime;
  String? closeTime;

  XFile? _shopLogo;

  Future<void> _pickShopLogo(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      setState(() {
        _shopLogo = pickedImage;
      });
    }
  }

  /// Flags for phone number
  String? flags;

  returnLabel(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      alignment: Alignment.centerLeft,
      child: Text(
        " $label",
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit App',
              style: TextStyle(
                  fontWeight: FontWeightManager.semiBold,
                  fontFamily: 'AppFonts',
                  fontSize: 18.sp,
                  color: ColorsManager.blackColor),
            ),
            content: Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'AppFonts',
                  color: ColorsManager.blackColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Cancel
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'AppFonts',
                      color: ColorsManager.blackColor),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // Exit
                child: Text(
                  'Exit',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'AppFonts',
                      color: ColorsManager.primaryColor),
                ),
              ),
            ],
          ),
        );
        return shouldExit ?? false; // Handle null case
      },
      child: Scaffold(
        backgroundColor: ColorsManager.offWhiteColor,
        body: Form(
          key: fcFormKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h),
                surfaceTintColor: ColorsManager.whiteColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: ColorsManager.lightGrey),
                    borderRadius: BorderRadius.circular(2.w)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 1.5.h,
                          bottom: 3.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'GoZip Seller',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeightManager.semiBold,
                                      fontSize: 16.sp),
                            ),
                            SizedBox(
                              width: 10.sp,
                            ),
                            IButton(
                                tooltipkey: tooltipkey,
                                message:
                                    "These details are used to create your shop")
                          ],
                        ),
                      ),

                      /// NAME
                      Column(
                        children: [
                          const ReturnLabel(label: "Shop Name"),
                          CustomFormField(
                            controller: shNameController,
                            hintText: "Name of Shop",
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter name of the Shop';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      /// Shop Logo
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: Column(
                          children: [
                            const ReturnLabel(label: "Shop Logo"),
                            SizedBox(
                              height: 1.w,
                            ),
                            InkWell(
                              onTap: () {
                                _pickShopLogo(ImageSource.gallery);
                              },
                              child: ProfilePhoto(profileImage: _shopLogo),
                            ),
                          ],
                        ),
                      ),

                      /// LOCATION
                      InputLocation(
                        locality: localityController,
                        locationController: locationController,
                      ),

                      /// MOBILE NUMBER
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 2.h),
                      //   child: Column(
                      //     children: [
                      //       const ReturnLabel(label: "Shop Phone number"),
                      //       DPhoneNumFiled(
                      //         labelText: false,
                      //         hintText: "Phone number",
                      //         contactEditingController: phoneNoController,
                      //         height: 6.h,
                      //         fontSize: 16.sp,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      /// OPEN - CLOSE TIME
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ReturnLabel(label: "Open Timing"),
                              InkWell(
                                onTap: () {
                                  showCustomTimePicker(context)
                                      .then((value) => setState(() {
                                            openTime = value;
                                          }));
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      openTime == null ? "00:00" : openTime!,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ReturnLabel(label: 'Close Time'),
                              InkWell(
                                onTap: () {
                                  showCustomTimePicker(context)
                                      .then((value) => setState(() {
                                            closeTime = value;
                                          }));
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 76, 75, 75)),
                                    borderRadius: BorderRadius.circular(5.sp),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      closeTime == null ? "00:00" : closeTime!,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Shop Description
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Column(
                          children: [
                            const ReturnLabel(label: "Shop Description"),
                            DescriptionFormField(
                              height: 20.h,
                              width: 90.h,
                              controller: procutDescripController,
                              hintText: "Enter the shop description",
                            )
                          ],
                        ),
                      ),

                      /// Dilivery Availability
                      SizedBox(
                        width: 90.w,
                        child: Row(
                          children: [
                            const ReturnLabel(label: "Delivery Availibility"),
                            Switch(
                              // thumb color (round icon)
                              activeColor: ColorsManager.accentColor,
                              activeTrackColor:
                                  ColorsManager.accentColor.withOpacity(0.17),
                              inactiveThumbColor: ColorsManager.lightGreyColor,
                              inactiveTrackColor: ColorsManager.offWhiteColor,
                              splashRadius: 50.0,
                              value: _dilivery,
                              onChanged: (value) {
                                setState(() {
                                  _dilivery = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      ToggleButton(
                        back: "Back",
                        next: "Next",
                        onPressedBack: () {
                          Navigator.pop(context);
                        },
                        onPressedNext: () {
                          if (fcFormKey.currentState!.validate() &&
                              openTime != null &&
                              closeTime != null &&
                              procutDescripController.text.isNotEmpty &&
                              localityController.text.isNotEmpty) {
                            LoadingDialog.showLoaderDialog(context);
                            ShopFormRepo.addForm1(
                              shopLogo: _shopLogo,
                              shNameIn: shNameController.text,
                              location: locationController.text,
                              address: localityController.text,
                              openTime: openTime ?? '',
                              closeTime: closeTime ?? '',
                              isAvailable: _dilivery,
                              shopDescription: procutDescripController.text,
                            ).then((value) {
                              Navigator.pop(context);
                              ConnectivityHelper.naviagte(
                                  context, Routes.form2);
                            });
                          } else if (openTime == null) {
                            customSnackBar(
                                context, "Pick The Open time", false);
                          } else if (closeTime == null) {
                            customSnackBar(
                                context, "Pick The Close time", false);
                          } else if (procutDescripController.text.isEmpty) {
                            customSnackBar(
                                context, "Pick The Close time", false);
                          } else if (localityController.text.isEmpty) {
                            customSnackBar(context, "Pick The Locality", false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
