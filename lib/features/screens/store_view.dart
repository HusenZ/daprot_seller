import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:daprot_seller/domain/shop_data_repo.dart';
import 'package:daprot_seller/features/screens/add_new_product.dart';
import 'package:daprot_seller/features/screens/product_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MyStore extends StatelessWidget {
  final ProductStream repository = ProductStream();

  MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

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
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: snapshot.data!.docs.first["shopImage"],
                    fit: BoxFit.cover,
                  ),
                ),
                floating: false,
                pinned: false,
                expandedHeight: 20.h,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(2.h),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data!.docs.first["shopLogo"]),
                    backgroundColor: Colors.white,
                    radius: 25.sp,
                  ),
                ),
              ),
              BottomTitle(
                  shopName: snapshot.data!.docs.first["name"],
                  openTime: snapshot.data!.docs.first["openTime"],
                  closeTime: snapshot.data!.docs.first["closeTime"],
                  locaion: snapshot.data!.docs.first["location"]),
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
                                            color: ColorsManager.offWhiteColor),
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
                          DocumentSnapshot product = snapshot.data!.docs[index];
                          return RowOfProductCard(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                    product: ProductFromDB(
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
  const BottomTitle(
      {super.key,
      required this.shopName,
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
              Text(
                locaion,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, color: ColorsManager.greyColor),
              ),
              SizedBox(
                width: 4.w,
              ),
              Icon(
                Icons.location_on,
                size: 2.h,
                color: ColorsManager.greyColor,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
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
          SizedBox(
            height: 1.h,
          ),
        ],
      )
    ]);
  }
}
