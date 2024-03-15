import 'dart:io';
import 'package:daprot_seller/bloc/sh_bloc/sh_bloc.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_event.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/d_phone_input_field.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:daprot_seller/features/widgets/form_widgets/input_brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../bloc/sh_bloc/sh_state.dart';
import '../../../domain/connectivity_helper.dart';

class FCScreen2 extends StatefulWidget {
  const FCScreen2({super.key});

  @override
  State<FCScreen2> createState() => FCScreen2State();
}

class FCScreen2State extends State<FCScreen2> {
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController ownerPhoneController = TextEditingController();
  TextEditingController ownerPanController = TextEditingController();

  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();

  XFile? _ownerPic;
  XFile? _bannerImage;

  Future<void> _ownerImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _ownerPic = pickedImage;
      });
    }
  }

  Future<void> _shopBannerImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _bannerImage = pickedImage;
      });
    }
  }

  Widget returnLabel(String label) {
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
    return BlocBuilder<ShBloc, ShState>(
      builder: (context, state) {
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
                        /// TITLE
                        Padding(
                          padding: EdgeInsets.only(
                            top: 1.5.h,
                            bottom: 3.h,
                          ),
                          child: Text(
                            'Daprot Shop',
                            style: TextStyle(
                                fontWeight: FontWeightManager.semiBold,
                                fontSize: 16.sp),
                          ),
                        ),

                        Column(
                          children: [
                            const ReturnLabel(label: "Banner Image"),
                            _bannerImage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          _shopBannerImage(ImageSource.gallery);
                                        },
                                        child: SizedBox(
                                          width: 80.w,
                                          height: 20.h,
                                          child: Image.file(
                                            File(_bannerImage!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: InkWell(
                                      onTap: () {
                                        _shopBannerImage(ImageSource.gallery);
                                      },
                                      child: const InputBrandLogoUi(),
                                    ),
                                  )
                          ],
                        ),

                        /// OWNER DETAILS
                        Padding(
                          padding: EdgeInsets.only(
                            top: 1.5.h,
                            bottom: 3.h,
                          ),
                          child: Text(
                            "Owner Details",
                            style: TextStyle(
                                fontWeight: FontWeightManager.semiBold,
                                fontSize: 16.sp),
                          ),
                        ),

                        /// Owners photo

                        Column(
                          children: [
                            const ReturnLabel(label: "Upload your photo"),
                            _ownerPic != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          _ownerImage(ImageSource.gallery);
                                        },
                                        child: Image.file(
                                          File(_ownerPic!.path),
                                          width: 40.w,
                                          height: 50.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: InkWell(
                                      onTap: () {
                                        _ownerImage(ImageSource.gallery);
                                      },
                                      child: const InputBrandLogoUi(),
                                    ),
                                  ),
                          ],
                        ),

                        SizedBox(
                          height: 4.h,
                        ),

                        /// NAME
                        Column(
                          children: [
                            const ReturnLabel(label: "Owner Name"),
                            CustomFormField(
                              controller: ownerNameController,
                              hintText: 'Type here',
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name of the Restaurant';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        /// MOBILE NUMBER
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Column(
                            children: [
                              const ReturnLabel(label: "Owner Phone number"),
                              DPhoneNumFiled(
                                labelText: false,
                                hintText: 'Phone number',
                                contactEditingController: ownerPhoneController,
                                height: 6.h,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),

                        /// PAN NO.
                        Column(
                          children: [
                            const ReturnLabel(label: "Pan Number"),
                            CustomFormField(
                              controller: ownerPanController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter the PAN number';
                                }
                                String panCardRegex =
                                    r'^[A-Z]{5}[0-9]{4}[A-Z]$';

                                if (!RegExp(panCardRegex).hasMatch(value)) {
                                  return 'Enter a valid PAN Card number';
                                }
                                return null;
                              },
                              hintText: 'Type here',
                            ),
                          ],
                        ),

                        ToggleButton(
                          back: "Cancel",
                          next: "Next",
                          onPressedBack: () {
                            Navigator.pop(context);
                          },
                          onPressedNext: () {
                            if (fcFormKey.currentState!.validate() &&
                                ownerPhoneController.text.isNotEmpty &&
                                ownerPhoneController.text.length == 10) {
                              context.read<ShBloc>().add(ShForm2Event(
                                    bannerImage: _bannerImage,
                                    ownerPhoto: _ownerPic,
                                    fullName: ownerNameController.text,
                                    phoneNumber: ownerPhoneController.text,
                                    panNumber: ownerPanController.text,
                                  ));
                              ConnectivityHelper.naviagte(
                                  context, Routes.form3);
                            } else if (_bannerImage == null) {
                              customSnackBar(
                                  context,
                                  "Please upload the Food Court Images!",
                                  false);
                            } else if (ownerPhoneController.text.isEmpty) {
                              customSnackBar(context,
                                  "Please enter your Mobile Number", false);
                            } else if (ownerPhoneController.text.length != 10) {
                              customSnackBar(context,
                                  "Enter a valid Mobile Number", false);
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
      },
    );
  }
}
