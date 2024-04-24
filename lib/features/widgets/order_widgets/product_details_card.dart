import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:flutter/material.dart';

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
