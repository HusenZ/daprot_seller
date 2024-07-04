import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:daprot_seller/domain/shop_data_repo.dart';
import 'package:daprot_seller/features/screens/add_new_product.dart';
import 'package:daprot_seller/features/screens/product_details_screen.dart';
import 'package:daprot_seller/features/screens/update_shop_details.dart';
import 'package:daprot_seller/features/widgets/store_widgets/bottom_view.dart';
import 'package:daprot_seller/features/widgets/store_widgets/store_product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

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
                    height: 4.h,
                    width: 45.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: ColorsManager.primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: Center(
                        child: Text(
                          "Add Products",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
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
                            child: SizedBox(
                          height: 5.h,
                        ));
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
                            return StoreViewProductCard(
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
                    }),
                SliverToBoxAdapter(
                  child: Center(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddNewProdcut(),
                      )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.sp),
                        child: Container(
                          height: 4.h,
                          width: 45.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: ColorsManager.primaryColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: Center(
                              child: Text(
                                "Add Products",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
