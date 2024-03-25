import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/features/screens/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OrdersTab extends StatelessWidget {
  final OrderRepository orderRepository = OrderRepository();

  OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color.fromARGB(232, 3, 115, 244),
      ),
      body: StreamBuilder<List<OrderModel>>(
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              OrderModel order = snapshot.data![index];
              return Material(
                elevation: 2.h,
                child: ListTile(
                  title: Text('Product: ${order.orderItems.first.name}'),
                  subtitle: Text('Total Price: \$${order.totalPrice}'),
                  trailing: Text('Status: ${order.orderStatus}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
