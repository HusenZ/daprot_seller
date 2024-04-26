import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:daprot_seller/domain/shop_data_repo.dart';
import 'package:daprot_seller/features/screens/add_new_product.dart';
import 'package:daprot_seller/features/screens/product_details_screen.dart';
import 'package:daprot_seller/features/screens/update_shop_details.dart';
import 'package:daprot_seller/features/widgets/common_widgets/expandable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MyStore extends StatefulWidget {
  const MyStore({super.key});

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 218, 40, 40),
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  final ProductStream repository = ProductStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: repository.getShopStream(uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddNewProdcut(),
                )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.sp),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: const Text("Add Products"),
                  ),
                ),
              ),
            );
          }
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        SizedBox(
                          height: 22.h,
                          width: 100.w,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.docs.first["shopImage"],
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 13.h,
                          left: 85.w,
                          child: IconButton.outlined(
                            color: ColorsManager.whiteColor,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateShopData(
                                    shName: snapshot.data!.docs.first['name'],
                                    phone: snapshot.data!.docs.first["phoneNo"],
                                    description: snapshot
                                        .data!.docs.first["description"],
                                    delivery:
                                        snapshot.data!.docs.first["dilivery"],
                                    openTime:
                                        snapshot.data!.docs.first["openTime"],
                                    closeTime:
                                        snapshot.data!.docs.first["closeTime"],
                                    shopbanner:
                                        snapshot.data!.docs.first["shopImage"],
                                    shopLogo:
                                        snapshot.data!.docs.first["shopLogo"]),
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floating: false,
                  pinned: false,
                  expandedHeight: 20.h,
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(2.h),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 27.sp,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!.docs.first["shopLogo"]),
                        radius: 25.sp,
                      ),
                    ),
                  ),
                ),
                BottomTitle(
                  shopName: snapshot.data!.docs.first["name"],
                  openTime: snapshot.data!.docs.first["openTime"],
                  closeTime: snapshot.data!.docs.first["closeTime"],
                  locaion: snapshot.data!.docs.first["location"],
                  description: snapshot.data!.docs.first["description"],
                ),
                StreamBuilder(
                    stream: repository.getProductStream(uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddNewProdcut(),
                              )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.sp),
                                child: Container(
                                  width: 22.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: ColorsManager.primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Add Products",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color:
                                                  ColorsManager.offWhiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            DocumentSnapshot product =
                                snapshot.data!.docs[index];
                            return RowOfProductCard(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                      product: ProductFromDB(
                                    subCategory: product['subCategory'],
                                    name: product['name'],
                                    description: product['description'],
                                    price: product['price'],
                                    discountedPrice: product['discountedPrice'],
                                    photos: product['selectedPhotos'],
                                    productId: product['productId'],
                                    category: product['category'],
                                  )),
                                ));
                              },
                              title: product['name'],
                              price: product['price'],
                              image: product['selectedPhotos'].first,
                            );
                          },
                          childCount: snapshot.data!.docs.length,
                        ),
                      );
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String bannerImage;
  final String logo;
  final String shopName;

  const BannerWidget(
      {super.key,
      required this.bannerImage,
      required this.logo,
      required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            image: DecorationImage(
              image: NetworkImage(bannerImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 17.h, left: 15.h, right: 15.h),
                  child: CircleAvatar(
                    radius: 32.sp,
                    backgroundColor: ColorsManager.whiteColor,
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: CachedNetworkImage(
                      //   imageUrl: logo,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RowOfProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final VoidCallback onTap;
  const RowOfProductCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Material(
          elevation: 4.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.sp),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 30.h,
              width: 35.w,
              color: ColorsManager.whiteColor,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    height: 30.h,
                    width: 35.w,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(1), BlendMode.dstATop),
                          image: NetworkImage(image)),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(160, 3, 115, 244),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          text: TextSpan(
                            text: title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorsManager.whiteColor),
                          ),
                        ),
                        Text(
                          "\$$price",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: ColorsManager.whiteColor),
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
    );
  }
}

class BottomTitle extends StatelessWidget {
  final String shopName;
  final String openTime;
  final String closeTime;
  final String locaion;
  final String description;
  const BottomTitle(
      {super.key,
      required this.shopName,
      required this.description,
      required this.openTime,
      required this.closeTime,
      required this.locaion});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      Column(
        children: [
          Text(
            shopName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 15.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.sp),
                child: Icon(
                  Icons.location_on,
                  size: 2.h,
                  color: const Color.fromARGB(146, 82, 78, 78),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              SizedBox(
                width: 90.w,
                child: Text(
                  locaion,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 10.sp,
                      color: const Color.fromARGB(146, 120, 117, 117)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About:",
                    style: TextStyle(
                      color: const Color.fromARGB(146, 120, 117, 117),
                      fontSize: 12.sp,
                    ),
                  ),
                  ExpandableText(description),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Time: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              Text(
                openTime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp, color: ColorsManager.accentColor),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                "Close Time: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                closeTime,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}
