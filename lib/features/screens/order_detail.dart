import 'package:daprot_seller/bloc/order_bloc/order_bloc.dart';
import 'package:daprot_seller/bloc/order_bloc/order_events.dart';
import 'package:daprot_seller/bloc/order_bloc/order_states.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/order_widgets/product_details_card.dart';
import 'package:daprot_seller/features/widgets/order_widgets/user_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderStatus _selectedStatus = OrderStatus.pending;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderUpdateSuccess) {
          customSnackBar(context, 'Status Updated', true);
        }
        if (state is OrderUpdateFailure) {
          customSnackBar(context, 'Status Updated Failed', false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.order.orderStatus.toUpperCase()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserDetailsCard(order: widget.order),
                const SizedBox(height: 16.0),
                ProductDetailsCard(order: widget.order),
                ElevatedButton(
                  onPressed: () async {
                    OrderStatus? selectedStatus = await showDialog<OrderStatus>(
                      context: context,
                      builder: (context) => _OrderStatusDialog(
                        orderBloc: BlocProvider.of<OrderBloc>(context),
                        order: widget.order,
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
                          orderId: widget.order.orderId,
                          userId: widget.order.userId,
                          newStatus: selectedStatus.name,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.accentColor),
                  child: Text(
                    widget.order.orderStatus.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 9.5.sp,
                          color: widget.order.orderStatus ==
                                  OrderStatus.cancelled.name
                              ? Colors.red
                              : Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            backgroundColor: ColorsManager.accentColor.withOpacity(0.75),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: ColorsManager.whiteColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.orderBloc.add(
              UpdateOrderStatus(
                orderId: widget.order.orderId,
                newStatus: _selectedStatus.name,
                userId: widget.order.userId,
              ),
            );
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.secondaryColor,
          ),
          child: const Text(
            'Update',
            style: TextStyle(color: ColorsManager.whiteColor),
          ),
        ),
      ],
    );
  }
}
