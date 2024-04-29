import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                width: 30.w,
                height: 15.h,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 3,
                    textDirection: TextDirection.ltr,
                    softWrap: true,
                    text: TextSpan(
                      text: order.orderItems.first.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 12.sp,
                            color: ColorsManager.blackColor,
                          ),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text('Price: \$${order.orderItems.first.price}'),
                  SizedBox(height: 1.h),
                  Text('Quantity: \$${order.quantity}'),
                  SizedBox(height: 1.h),
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
//order.orderItems.first.name,