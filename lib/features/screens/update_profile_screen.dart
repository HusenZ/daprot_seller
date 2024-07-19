import 'package:gozip_seller/bloc/update_user_bloc/update_event_event.dart';
import 'package:gozip_seller/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:gozip_seller/bloc/update_user_bloc/update_user_state.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/config/theme/fonts_manager.dart';
import 'package:gozip_seller/domain/user_data_repo.dart';
import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/loading_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen(
      {super.key,
      this.userPhone,
      this.userId,
      this.userEmail,
      this.userName,
      this.profileImg});

  final String? profileImg;
  final String? userPhone;
  final String? userId;
  final String? userEmail;
  final String? userName;

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserDataManager userOrderRepository = UserDataManager();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //Shipping controllers

  bool isLoading = false;
  bool profileUpdated = false;

  final GlobalKey<FormState> _setProfileFormKey = GlobalKey<FormState>();

  Widget returnLabel(String label) {
    return Container(
      padding: EdgeInsets.only(left: 3.w, bottom: 1.w),
      alignment: Alignment.centerLeft,
      child: Text(
        " $label",
        style:
            TextStyle(fontSize: FontSize.s14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName!;
    _emailController.text = widget.userEmail!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final inputTextSize = screenWidth * 0.04;
    return BlocListener<UserUpdateBloc, UserUpdateState>(
      listener: (context, state) {
        if (state is UserUpdateSuccess) {
          Navigator.pop(context);
        }
        if (state is UserUpdateLoading) {}
      },
      child: BlocBuilder<UserUpdateBloc, UserUpdateState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.h),
                child: Form(
                  key: _setProfileFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: [
                          returnLabel("Name"),
                          SizedBox(
                            width: 85.w,
                            height: 8.h,
                            child: DTextformField(
                              readOnly: false,
                              controller: _nameController,
                              hintText: widget.userName,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your Full Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: [
                          returnLabel("Email"),
                          SizedBox(
                            width: 85.w,
                            height: 8.h,
                            child: DTextformField(
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              hintText: widget.userEmail,
                              inputTextSize: inputTextSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: [
                          returnLabel("Phone number"),
                          Container(
                            width: 85.w,
                            height: 8.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorsManager.greyColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.userPhone ?? 'no num',
                              style: const TextStyle(fontSize: FontSize.s18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Do it Later!",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      isLoading
                          ? const LoadingButton()
                          : DelevatedButton(
                              text: 'SAVE',
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });

                                BlocProvider.of<UserUpdateBloc>(context)
                                    .add(UpdateUserEvent(
                                  userId: widget.userId!,
                                  phone: widget.userPhone!,
                                  name: _nameController.text,
                                  email: widget.userEmail!,
                                ));
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
