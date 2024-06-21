import 'package:cached_network_image/cached_network_image.dart';
import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/features/screens/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  final OrderRepository orderRepository = OrderRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: ColorsManager.secondaryColor,
        bottom: TabBar(
          unselectedLabelColor: ColorsManager.whiteColor,
          labelColor: const Color.fromRGBO(206, 182, 236, 1),
          labelStyle:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12.sp),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersTab(OrderStatus.pending),
          _buildOrdersTab(OrderStatus.delivered),
          _buildOrdersTab(OrderStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(OrderStatus status) {
    return StreamBuilder<List<OrderModel>>(
      stream: orderRepository
          .getUserOrdersStream(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error is here: ${snapshot.error}'),
          );
        }
        if (snapshot.data == null) {
          return const Center(child: Text("NO DATA"));
        }
        if (snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(left: 8.h, right: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppLottie.splashScreenBottom,
                    width: 90.w,
                    height: 60.w,
                    repeat: true,
                    reverse: false,
                    animate: true,
                    fit: BoxFit.cover),
                Text(
                  "NO ORDERS AVAILABLE",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          );
        }
        List<OrderModel> filteredOrders = snapshot.data!
            .where((order) => order.orderStatus == status.name)
            .toList();

        if (filteredOrders.isEmpty) {
          return const Center(
            child: Text("No orders with this status"),
          );
        }
        if (status.name == OrderStatus.pending.name) {
          filteredOrders.sort((a, b) {
            return a.orderDate.compareTo(b.orderDate);
          });
        }

        return ListView.builder(
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            OrderModel order = filteredOrders[index];
            return Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Material(
                elevation: 2.sp,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 10.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: order.orderItems.first.imageUrl.first,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 2.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 66.w,
                              child: Text(
                                'Product: ${order.orderItems.first.name}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 13.sp),
                              )),
                          Text(
                            'Quantity: ${order.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 12.sp,
                                    color: const Color.fromARGB(
                                        146, 107, 101, 101)),
                          ),
                          Text(
                            'Total Price: ₹ ${order.totalPrice}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 12.sp, color: Colors.black87),
                          ),
                          Text(
                            order.orderStatus.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: order.orderStatus ==
                                              OrderStatus.cancelled.name
                                          ? Colors.red
                                          : order.orderStatus ==
                                                  OrderStatus.delivered.name
                                              ? const Color.fromARGB(
                                                  255, 4, 242, 127)
                                              : ColorsManager.accentColor,
                                      fontSize: 14.sp,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
