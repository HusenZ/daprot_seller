import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_events.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_text_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/profile_photo_widget.dart';
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
  final TextEditingController _emailController = TextEditingController();
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
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String phoneNumber;

    // final GlobalKey<FormState> _setProfileFormKey = GlobalKey<FormState>();

    final inputTextSize = screenWidth * 0.04;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, String>{}) as Map;
    phoneNumber = arguments['phoneNumber'];
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
                CustomTextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the Name';
                    }
                    return null;
                  },
                  inputTextSize: inputTextSize,
                  label: 'Name',
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomTextFormField(
                    controller: _emailController,
                    inputTextSize: inputTextSize,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the Email address';
                      }
                      String emailRegex =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      if (!RegExp(emailRegex).hasMatch(value)) {
                        return 'Enter a valid Email address';
                      }
                      return null;
                    },
                    label: 'Email'),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  height: 8.h,
                  width: 98.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all()),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(phoneNumber)),
                ),
                SizedBox(height: screenHeight * 0.03),
                isLoading
                    ? const LoadingButton()
                    : DelevatedButton(
                        text: 'Create Account',
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          BlocProvider.of<AppBloc>(context).add(SignUpEvent(
                            fullName: _nameController.text,
                            email: _emailController.text,
                            phoneNumber: phoneNumber,
                            profile: _profileImage,
                            context: context,
                          ));
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
