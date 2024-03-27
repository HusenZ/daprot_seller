import 'package:daprot_seller/bloc/order_bloc/order_bloc.dart';
import 'package:daprot_seller/bloc/order_bloc/order_events.dart';
import 'package:daprot_seller/bloc/order_bloc/order_states.dart';
import 'package:daprot_seller/config/constants/lottie_img.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/features/screens/order_detail.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final OrderRepository orderRepository = OrderRepository();
  OrderStatus _selectedStatus = OrderStatus.pending;

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

          return BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderUpdateSuccess) {
                customSnackBar(context, 'Status Updated', true);
              }
              if (state is OrderUpdateFailure) {
                customSnackBar(context, 'Status Updated Failed', false);
              }
            },
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                OrderModel order = snapshot.data![index];
                return Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                  child: Material(
                    elevation: 2.h,
                    child: ListTile(
                      title: Text('Product: ${order.orderItems.first.name}'),
                      titleTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 12.sp),
                      subtitle: Text('Total Price: \$${order.totalPrice}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              OrderStatus? selectedStatus =
                                  await showDialog<OrderStatus>(
                                context: context,
                                builder: (context) => _OrderStatusDialog(
                                  orderBloc:
                                      BlocProvider.of<OrderBloc>(context),
                                  order: order,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  },
                                ),
                              );

                              if (selectedStatus != null) {
                                BlocProvider.of<OrderBloc>(context).add(
                                  UpdateOrderStatus(
                                    orderId: order.orderId,
                                    newStatus: selectedStatus.name,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.accentColor),
                            child: Text(
                              order.orderStatus.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 9.5.sp,
                                    color: order.orderStatus ==
                                            OrderStatus.cancelled.name
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderStatusDialog extends StatefulWidget {
  final OrderBloc orderBloc;
  final ValueChanged<OrderStatus> onChanged;
  final OrderModel order;

  const _OrderStatusDialog({
    required this.orderBloc,
    required this.order,
    required this.onChanged,
  });

  @override
  __OrderStatusDialogState createState() => __OrderStatusDialogState();
}

class __OrderStatusDialogState extends State<_OrderStatusDialog> {
  late OrderStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = OrderStatus.pending; // Set initial selected status
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Order Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: OrderStatus.values.map((status) {
          return RadioListTile<OrderStatus>(
            title: Text(status.name),
            value: status,
            groupValue: _selectedStatus,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
          );
        }).toList(),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.lightRedColor,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.orderBloc.add(
              UpdateOrderStatus(
                orderId: widget.order.orderId,
                newStatus: _selectedStatus.name,
              ),
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.accentColor,
          ),
          child: const Text('Update'),
        ),
      ],
    );
  }
}
