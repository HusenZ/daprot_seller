import 'dart:io';
import 'package:daprot_seller/bloc/sh_bloc/sh_bloc.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_event.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:daprot_seller/features/widgets/form_widgets/input_brand_logo.dart';
import 'package:daprot_seller/features/widgets/form_widgets/terms_cond_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class FCScreen3 extends StatefulWidget {
  const FCScreen3({super.key});

  @override
  State<FCScreen3> createState() => _FCScreen3State();
}

class _FCScreen3State extends State<FCScreen3> {
  bool _accepted = false;
  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();

  XFile? _gstImage;

  Future<void> _pickBannerImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _gstImage = pickedImage;
      });
    }
  }

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

  bool _accept = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShBloc, ShState>(
      listener: (context, state) {
        if (state is ShopLoadingState) {
          isLoading = true;
        }
        if (state is ShopSuccessState) {
          isLoading = false;
          Navigator.of(context).pushReplacementNamed(Routes.underReview);
        }
        if (state is ShopFailurState) {
          isLoading = false;
          customSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorsManager.offWhiteColor,

          //appBar: const CustomAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: fcFormKey,
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
                              'Shop Forms',
                              style: TextStyle(
                                  fontWeight: FontWeightManager.semiBold,
                                  fontSize: 16.sp),
                            ),
                          ),

                          /// Banner Image
                          Column(
                            children: [
                              const ReturnLabel(label: 'Gst Image'),
                              SizedBox(
                                height: 1.w,
                              ),
                              _gstImage != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            _pickBannerImage(
                                                ImageSource.gallery);
                                          },
                                          child: SizedBox(
                                            width: 70.w,
                                            height: 20.h,
                                            child: Image.file(
                                              File(_gstImage!.path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: InkWell(
                                        onTap: () {
                                          _pickBannerImage(ImageSource.gallery);
                                        },
                                        child: const InputBrandLogoUi(),
                                      ),
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),

                          /// AGREED TEXT
                          Container(
                            width: 90.w,
                            height: 10.h,
                            //  color: Colors.black,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Checkbox(
                                      activeColor: ColorsManager.accentColor,
                                      value: _accept,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _accept = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const TermsAndConditionBox()
                                ]),
                          ),

                          /// NAVIGATOR
                          if (isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ToggleButton(
                            back: "Cancel",
                            next: "Next",
                            onPressedBack: () {
                              Navigator.pop(context);
                            },
                            onPressedNext: () {
                              context.read<ShBloc>().add(
                                    ShForm3Event(
                                        gstImage: _gstImage,
                                        isAccepted: _accepted),
                                  );

                              /// FC Registered SANCKBAR
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(25),
                              //           topRight: Radius.circular(25))),
                              //   backgroundColor: ColorsManager.primaryColor,
                              //   content: Text(
                              //     "Successfully ENROLLED!!",
                              //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              //         color: ColorsManager.whiteColor,
                              //         fontSize: FontSize.s15.sp),
                              //   ),
                              //   duration: const Duration(seconds: 2),
                              // ));
                              if (_gstImage != null && _accept) {
                                context.read<ShBloc>().add(
                                      ShForm3Event(
                                          gstImage: _gstImage,
                                          isAccepted: _accept),
                                    );
                              } else if (!_accept) {
                                customSnackBar(
                                    context,
                                    "Please accept the TERMS and CONDITIONS!!",
                                    false);
                              } else if (_gstImage == null) {
                                customSnackBar(
                                    context,
                                    "Please upload all the required documents!",
                                    false);
                              }
                            },
                          ),
                        ]),
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
