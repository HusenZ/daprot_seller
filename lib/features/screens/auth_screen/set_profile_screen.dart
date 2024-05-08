import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/connectivity_helper.dart';
import 'package:daprot_seller/domain/sign_up_repo.dart';
import 'package:daprot_seller/features/screens/auth_screen/login_screen.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/profile_photo_widget.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  SetProfileScreenState createState() => SetProfileScreenState();
}

class SetProfileScreenState extends State<SetProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

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

    // final GlobalKey<FormState> _setProfileFormKey = GlobalKey<FormState>();
    String userName = user!.displayName!;
    String userEmail = user!.email!;

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppStateLoading) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Scaffold(
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
                Container(
                  height: 8.h,
                  width: 98.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all()),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Text(
                          user!.displayName ?? "user name",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )),
                ),
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
                          user!.email ?? "email",
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
                            SignUpApi.addUser(
                                    profile: _profileImage!,
                                    name: userName,
                                    email: userEmail,
                                    phone: _phoneController.text)
                                .then(
                              (value) {
                                if (value) {
                                  ConnectivityHelper.clareStackPush(
                                      context, Routes.homeRoute);
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
      ),
    );
  }
}
