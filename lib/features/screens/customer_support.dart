import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip_seller/config/constants/app_icons.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:gozip_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:gozip_seller/features/widgets/common_widgets/text_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CustomerSupport extends StatelessWidget {
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.dark,
    ));
    TextEditingController titleEditingController = TextEditingController();
    TextEditingController descripEditingController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          padding: EdgeInsets.all(8.sp),
          width: 5.w,
          height: 5.w,
          child: CircleAvatar(
            backgroundColor: ColorsManager.transparentColor,
            child: Image.asset(AppIcons.customerSupport),
          ),
        ),
        backgroundColor: ColorsManager.transparentColor,
        foregroundColor: ColorsManager.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.sp),
              child: DTextformField(
                controller: titleEditingController,
                key: formKey,
                readOnly: false,
                label: 'Describe Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 25.h,
              width: 95.w,
              child: Form(
                child: TextFormField(
                  controller: descripEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your review';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 100,
                  decoration: InputDecoration(
                    labelText: 'Describe Your Problem(optionals)',
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.textColor,
                              fontSize: 14.sp,
                            ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                  onChanged: (text) {},
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            DelevatedButton(
              text: 'Submit',
              onTap: () async {
                if (titleEditingController.text.isNotEmpty) {
                  LoadingDialog.showLoaderDialog(context);
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  final data = {
                    'userId': userId,
                    'title': titleEditingController.text,
                    'seller': true,
                    'description': descripEditingController.text.isEmpty
                        ? ''
                        : descripEditingController.text,
                  };
                  FirebaseFirestore.instance
                      .collection('Admin')
                      .doc('c&s')
                      .collection('support Query')
                      .doc(userId)
                      .set(
                        data,
                      )
                      .then(
                    (value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      customSnackBar(context, 'Message Sent Succefully', true);
                    },
                  );
                } else {
                  customSnackBar(context, 'Enter Title', false);
                }
              },
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ColorsManager.whiteColor,
                      ),
                  foregroundColor: ColorsManager.whiteColor,
                  backgroundColor: ColorsManager.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
