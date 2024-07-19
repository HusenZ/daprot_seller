import 'package:gozip_seller/config/routes/routes_manager.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/domain/connectivity_helper.dart';
import 'package:gozip_seller/domain/sign_up_repo.dart';
import 'package:gozip_seller/features/screens/auth_screen/login_screen.dart';
import 'package:gozip_seller/features/widgets/common_widgets/custom_text_field.dart';
import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/profile_photo_widget.dart';
import 'package:gozip_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EmailSetProfile extends StatefulWidget {
  const EmailSetProfile({super.key, required this.email});
  final String email;

  @override
  EmailSetProfileState createState() => EmailSetProfileState();
}

class EmailSetProfileState extends State<EmailSetProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  XFile? _profileImage;
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 0.15 * screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Stack(
                  children: [
                    ProfilePhoto(profileImage: _profileImage),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 24,
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomTextFormField(
                  controller: _nameController,
                  inputTextSize: 20,
                  label: 'Name'),
              SizedBox(height: screenHeight * 0.03),
              Container(
                height: 8.h,
                width: 98.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all()),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 97.w,
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text(
                        widget.email,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              InputTextField(contactEditingController: _phoneController),
              SizedBox(height: screenHeight * 0.03),
              isLoading
                  ? const LoadingButton()
                  : DelevatedButton(
                      text: 'Create Account',
                      onTap: () {
                        if (_phoneController.text.isEmpty) {
                          customSnackBar(
                              context, "Please Enter Phone number", false);
                        }
                        if (_profileImage == null) {
                          customSnackBar(
                              context, "Please Upload Profile Image", false);
                        }
                        if (_phoneController.text.isNotEmpty &&
                            _profileImage != null) {
                          setState(() {
                            isLoading = true;
                          });
                          SignUpApi.addUserEmailPass(
                                  profile: _profileImage!,
                                  name: _nameController.text,
                                  email: widget.email,
                                  phone: _phoneController.text)
                              .then(
                            (value) async {
                              if (value) {
                                ConnectivityHelper.clareStackPush(
                                    context, Routes.homeRoute);
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setBool("isAuthenticated", true);
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                customSnackBar(
                                    context, 'Something went wrong', false);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          );
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
