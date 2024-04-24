import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:daprot_seller/bloc/update_user_bloc/update_user_state.dart';
import 'package:daprot_seller/config/constants/app_icons.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/user_model.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/domain/user_data_repo.dart';
import 'package:daprot_seller/features/screens/update_profile_screen.dart';
import 'package:daprot_seller/features/widgets/common_widgets/single_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showLogoutDialog(BuildContext context, String imageUrl, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ColorsManager.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Goodbye, $name',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 2.h),
                const Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.whiteColor),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        final preferences =
                            await SharedPreferences.getInstance();
                        preferences.setBool('isAuthenticated', false);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Stay',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.whiteColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return BlocBuilder<UserUpdateBloc, UserUpdateState>(
      builder: (BuildContext context, UserUpdateState state) {
        return StreamBuilder<UserModel>(
            stream: UserDataManager().streamUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data;
                print(user!.imgUrl);
              }
              if (snapshot.data == null) {
                debugPrint('!! Snapshot is not having data !!');
                user = UserModel(
                    name: 'name',
                    email: 'email',
                    phNo: 'phNo',
                    imgUrl: 'profilePhoto',
                    uid: FirebaseAuth.instance.currentUser!.uid);
              }
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      backgroundColor: ColorsManager.whiteColor,
                      expandedHeight: 8.h,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          'Profile',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 18.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Card(
                            color: ColorsManager.whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user!.imgUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 17.w,
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            user!.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.h),
                                        child: StreamBuilder(
                                            stream: OrderRepository()
                                                .streamDeliveredOrdersCount(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text(
                                                  "Will be Updated Soon",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 10.sp,
                                                          color: ColorsManager
                                                              .greyColor),
                                                );
                                              }
                                              print(snapshot.data);
                                              return Text(
                                                "${snapshot.data!} Sales in a year",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontSize: 14.sp,
                                                        color: const Color
                                                            .fromARGB(146, 146,
                                                            143, 143)),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen(
                                  userId: user!.uid,
                                  profileImg: user!.imgUrl,
                                  userPhone: user!.phNo,
                                  userEmail: user!.email,
                                  userName: user!.name,
                                ),
                              ),
                            );
                          },
                          child: const DsingleChildCard(
                              title: "Personal Info",
                              image: AppIcons.profileIcon),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                            onTap: () async {
                              _showLogoutDialog(
                                  context, user!.imgUrl, user!.name);
                            },
                            child: const DsingleChildCard(
                                title: "Log Out", image: AppIcons.logoutIcon))
                      ],
                    ))
                  ],
                ),
              );
            });
      },
    );
  }
}
