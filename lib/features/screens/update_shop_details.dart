import 'dart:io';

import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/domain/shop_data_repo.dart';
import 'package:daprot_seller/domain/shop_form_repo.dart';
import 'package:daprot_seller/domain/time_picker.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_seller/features/widgets/common_widgets/profile_photo_widget.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/d_phone_input_field.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class UpdateShopData extends StatefulWidget {
  const UpdateShopData({
    super.key,
    required this.shName,
    required this.description,
    required this.delivery,
    required this.openTime,
    required this.closeTime,
    required this.shopbanner,
    required this.shopLogo,
  });
  final String shName;
  final String description;
  final bool delivery;
  final String openTime;
  final String closeTime;
  final String shopbanner;
  final String shopLogo;

  @override
  State<UpdateShopData> createState() => _UpdateShopDataState();
}

class _UpdateShopDataState extends State<UpdateShopData> {
  /// FORM KEY
  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();
  bool _dilivery = false;

  /// CONTROLLERS

  TextEditingController shNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? openTime;
  String? closeTime;

  XFile? _shopLogo;
  XFile? _pBannerPic;

  @override
  void initState() {
    super.initState();
    shNameController.text = widget.shName;
    descriptionController.text = widget.description;
    openTime = widget.openTime;
    closeTime = widget.closeTime;
  }

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

  Future<void> _pBanner(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      setState(() {
        _pBannerPic = pickedImage;
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

  final ProductStream repository = ProductStream();
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeightManager.semiBold,
                            fontSize: 16.sp),
                      ),
                    ),
                    // Shop Banner

                    returnLabel('Banner Image'),
                    _pBannerPic != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _pBanner(ImageSource.gallery);
                                },
                                child: SizedBox(
                                  width: 80.w,
                                  height: 20.h,
                                  child: Image.file(
                                    File(_pBannerPic!.path),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: InkWell(
                              onTap: () {
                                _pBanner(ImageSource.gallery);
                              },
                              child: Image.network(
                                widget.shopbanner,
                                height: 22.h,
                                width: 100.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                    /// Shop Logo
                    returnLabel('Shop Logo'),
                    _shopLogo != null
                        ? Padding(
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
                          )
                        : InkWell(
                            onTap: () {
                              _pickShopLogo(ImageSource.gallery);
                            },
                            child: ProfilePhotoNet(
                              profileImage: widget.shopLogo,
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
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Column(
                        children: [
                          const ReturnLabel(label: "Shop Description"),
                          DescriptionFormField(
                            height: 20.h,
                            width: 90.h,
                            controller: descriptionController,
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
                      next: "Update",
                      onPressedBack: () {
                        Navigator.pop(context);
                      },
                      onPressedNext: () {
                        if (fcFormKey.currentState!.validate() &&
                            openTime != null &&
                            closeTime != null &&
                            descriptionController.text.isNotEmpty) {
                          LoadingDialog.showLoaderDialog(context);
                          ShopFormRepo()
                              .updateShopData(
                                  closeTime: closeTime,
                                  openTime: openTime,
                                  isParking: _dilivery,
                                  shopImage: _pBannerPic,
                                  shopLogo: _shopLogo,
                                  productDescrip: descriptionController.text,
                                  shName: shNameController.text)
                              .then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        } else if (openTime == null) {
                          customSnackBar(context, "Pick The Open time", false);
                        } else if (closeTime == null) {
                          customSnackBar(context, "Pick The Close time", false);
                        } else if (descriptionController.text.isEmpty) {
                          customSnackBar(context, "Pick The Close time", false);
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
  }
}
