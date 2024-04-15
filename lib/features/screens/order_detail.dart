import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/model/user_model.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.orderStatus.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User details and shipping address card
            UserDetailsCard(order: order),
            const SizedBox(height: 16.0), // Add spacing between cards
            // Product details card
            ProductDetailsCard(order: order),
          ],
        ),
      ),
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  final OrderModel order;
  final OrderRepository repo = OrderRepository();

  UserDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<UserModel>(
            stream: repo.streamUser(order.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data;
              }
              if (!snapshot.hasData) {
                debugPrint('!! Snapshot is not having data !!');
                user = UserModel(
                    name: 'name',
                    email: 'email',
                    phNo: 'phNo',
                    imgUrl: 'profilePhoto',
                    uid: '');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text('Name: ${user!.name}'),
                  Text('Phone: ${user!.phNo}'),
                  const Divider(thickness: 1.0),
                  Text(
                    'Shipping Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class ProductDetailsCard extends StatelessWidget {
  final OrderModel order;

  const ProductDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Display product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                order.orderItems.first.imageUrl.first,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderItems.first.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4.0),
                  Text('Price: \$${order.orderItems.first.price}'),
                  const SizedBox(height: 4.0),
                  Text('Total: ${order.totalPrice}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
