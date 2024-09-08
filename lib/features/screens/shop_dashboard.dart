import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip_seller/config/routes/routes_manager.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/domain/connectivity_helper.dart';
import 'package:gozip_seller/domain/order_repo.dart';
import 'package:gozip_seller/features/screens/orders_screen.dart';
import 'package:gozip_seller/features/screens/profile_screen.dart';
import 'package:gozip_seller/features/screens/store_view.dart';
import 'package:gozip_seller/features/widgets/products_review_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({super.key});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  int _selectedIndex = 0;

  void notificationService() async {
    FirebaseMessaging fmessaging = FirebaseMessaging.instance;
    await fmessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await fmessaging.getToken().then(
      (value) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        print(userId);
        FirebaseFirestore.instance.collection('Shops').doc(userId).update({
          'fcmToken': value,
        });
      },
    );
  }

  @override
  void initState() {
    notificationService();
    super.initState();
  }

  final List _tabs = [
    const ShopDashboard(),
    const OrdersTab(),
    const MyStore(),
    const ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    double change = 0.0, // No change by default
    IconData? icon,
  }) {
    final color = change > 0 ? Colors.green : (change < 0 ? Colors.red : null);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 2.h, color: color),
            if (icon != null) SizedBox(width: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: title == 'Total Sales'
                      ? TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        )
                      : TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                ),
                Text(
                  value,
                  style: title == 'Total Sales'
                      ? TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        )
                      : TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Scaffold dashboardView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.secondaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: ColorsManager.whiteColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ConnectivityHelper.naviagte(context, Routes.addNewProduct);
        },
        backgroundColor: ColorsManager.secondaryColor,
        splashColor: ColorsManager.offWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.sp),
        ),
        child: const Icon(
          Icons.add_circle,
          color: ColorsManager.whiteColor,
          size: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Live Data",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 14.sp, color: Colors.red),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: OrderRepository().streamDeliveredOrdersCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          const Card(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return _buildKPICard(
                          title: 'Total Sales',
                          value: (snapshot.data ?? 0).toString(),
                        );
                      }),
                  StreamBuilder(
                      stream: OrderRepository().streamPendingOrdersCount(),
                      builder: (context, snapshot) {
                        return _buildKPICard(
                          title: 'New Orders',
                          value: (snapshot.data ?? 0).toString(),
                        );
                      }),
                ],
              ),
              SizedBox(height: 4.h),
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reviews",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14.sp,
                      ),
                ),
              ),
              SizedBox(
                height: 55.h,
                child: const ProductReviewCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme:
            const IconThemeData(color: ColorsManager.primaryColor),
        unselectedIconTheme:
            const IconThemeData(color: Color.fromARGB(146, 108, 107, 107)),
        selectedLabelStyle: const TextStyle(color: ColorsManager.primaryColor),
        selectedItemColor: ColorsManager.primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_checkout), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body:
          _selectedIndex == 0 ? dashboardView(context) : _tabs[_selectedIndex],
    );
  }
}

// class ProductReviewCard extends StatelessWidget {
//   ProductReviewCard({super.key});
//   ProductStream productStream = ProductStream();
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
//       stream: productStream.getProductReviewsStream(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Will Be Updated Later');
//         }

//         if (snapshot.data == null) {
//           return const Center(
//             child: Text("No Data Available"),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final reviews = snapshot.data!;
//         return ListView.builder(
//           shrinkWrap: true, // Prevent excessive scrolling
//           itemCount: reviews.length,
//           itemBuilder: (context, index) {
//             final productReviews = reviews[index].docs;

//             if (productReviews.isEmpty) {
//               return const Text('');
//             }

//             return SingleChildScrollView(
//               child: Column(
//                 // Wrap reviews in a Column
//                 children: productReviews.map((reviewDoc) {
//                   final reviewText = reviewDoc.get('review');
//                   return Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         StreamBuilder<UserModel>(
//                           stream: OrderRepository()
//                               .streamUser(reviewDoc.get('userID')),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return const Text('Will Be Updated Later');
//                             }

//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Shimmer(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.grey[300]!,
//                                     Colors.grey[100]!
//                                   ],
//                                   stops: const [0.1, 0.9],
//                                 ),
//                                 child: Container(
//                                   width: 90.w,
//                                   height: 70.h,
//                                   color: Colors.grey[200],
//                                   child: const Card(),
//                                 ),
//                               );
//                             }
//                             return Row(
//                               children: [
//                                 const CircleAvatar(
//                                   backgroundColor: Colors.white,
//                                   child: Icon(Icons.person),
//                                 ),
//                                 SizedBox(
//                                   width: 2.w,
//                                 ),
//                                 SizedBox(
//                                   width: 70.w,
//                                   child: Text(
//                                     snapshot.data!.name,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .copyWith(
//                                             overflow: TextOverflow.ellipsis,
//                                             fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(8.sp),
//                               child: Text(
//                                   '${(reviewDoc.get('rating')).toString()}/5.0'),
//                             ),
//                             RatingBarIndicator(
//                               rating: reviewDoc.get('rating'),
//                               direction: Axis.horizontal,
//                               itemCount: 5,
//                               itemSize: 24,
//                               itemBuilder: (context, _) => const Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.sp),
//                           child: Text(reviewText),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
