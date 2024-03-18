import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/features/screens/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrdersTab extends StatelessWidget {
  final OrderRepository orderRepository = OrderRepository();

  OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
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
            return const Center(
              child: Text('No orders found.'),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Orders.'),
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
