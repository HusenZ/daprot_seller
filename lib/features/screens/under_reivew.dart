import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class UnderReivew extends StatefulWidget {
  const UnderReivew({super.key});

  @override
  State<UnderReivew> createState() => _UnderReivewState();
}

class _UnderReivewState extends State<UnderReivew> {
  Map<String, dynamic> map = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchClientData().then((value) {
      setState(() {
        map = value;
        isLoading = false;
      });
    });
  }

  Future<Map<String, dynamic>> fetchClientData() async {
    // Get the current user ID

    final userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    // Access the document in the 'Sellers' collection with the user's ID
    final clientDoc =
        await FirebaseFirestore.instance.collection('Shops').doc(userId).get();

    if (!clientDoc.exists) {
      throw Exception('Client document not found');
    }

    print(clientDoc);

    // Extract the 'brandLogoImage' and 'name' fields
    final String brandLogoImage = clientDoc['shopLogo'];
    print("brandLogoImage");

    print(brandLogoImage);

    final String name = clientDoc['name'];
    final String location = clientDoc['location'];

    return {
      'brandLogoImage': brandLogoImage,
      'name': name,
      'location': location
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 247, 242, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(114, 247, 242, 255),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 0, 0),
          child: InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            },
            child: const CircleAvatar(
                backgroundColor: ColorsManager.lightGrey,
                child: Icon(Icons.arrow_back_ios_new)),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            'Daprot Shop',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 14.sp, fontWeight: FontWeightManager.semiBold),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryColor,
              ),
            )
          : Center(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                  child: SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: map['brandLogoImage'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ClipOval(
                            child: Container(
                              color: ColorsManager.accentColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        map['name'],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16.sp,
                            ),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color.fromARGB(200, 198, 194, 194),
                          ),
                          SizedBox(
                            width: 90.w,
                            child: Text(
                              map['location'],
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: ColorsManager.secondaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeightManager.semiBold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Card(
                    color: ColorsManager.secondaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text(
                        'We have received your \n verification request...',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 10.sp,
                              color: ColorsManager.whiteColor,
                              fontWeight: FontWeightManager.semiBold,
                            ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
    );
  }
}
