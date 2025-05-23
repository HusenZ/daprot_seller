import 'package:daprot_seller/bloc/sh_bloc/sh_bloc.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_event.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/domain/time_picker.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/profile_photo_widget.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/d_phone_input_field.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  TextEditingController phoneNoController = TextEditingController();
  String? openTime;
  String? closeTime;

  XFile? _shopLogo;

  Future<void> _pickShopLogo(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
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
    return BlocBuilder<ShBloc, ShState>(builder: (context, state) {
      return Scaffold(
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
                        child: Text(
                          'Daprot Seller',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeightManager.semiBold,
                                  fontSize: 16.sp),
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
                      Column(
                        children: [
                          returnLabel("Location"),
                          InputLocation(
                            locationController: locationController,
                          ),
                        ],
                      ),

                      /// MOBILE NUMBER
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Column(
                          children: [
                            const ReturnLabel(label: "Shop Phone number"),
                            DPhoneNumFiled(
                              labelText: false,
                              hintText: "Phone number",
                              contactEditingController: phoneNoController,
                              height: 6.h,
                              fontSize: 16.sp,
                            ),
                          ],
                        ),
                      ),

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
                              phoneNoController.text.isNotEmpty &&
                              phoneNoController.text.length == 10 &&
                              openTime != null &&
                              closeTime != null) {
                            context.read<ShBloc>().add(
                                  ShForm1Event(
                                    brandlogo: _shopLogo,
                                    shName: shNameController.text,
                                    location: locationController.text,
                                    phoneNumber: phoneNoController.text,
                                    openTime: openTime ?? '',
                                    closeTime: closeTime ?? '',
                                    isParking: _dilivery,
                                  ),
                                );
                            ConnectivityHelper.naviagte(context, Routes.form2);
                          } else if (phoneNoController.text.isEmpty) {
                            customSnackBar(context,
                                "Please enter your Mobile Number", false);
                          } else if (phoneNoController.text.length != 10) {
                            customSnackBar(
                                context, "Enter a valid Mobile Number", false);
                          } else if (openTime == null) {
                            customSnackBar(
                                context, "Pick The Open time", false);
                          } else if (closeTime == null) {
                            customSnackBar(
                                context, "Pick The Close time", false);
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
      );
    });
  }
}
