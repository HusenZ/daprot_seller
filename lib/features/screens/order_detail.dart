import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/bloc/order_bloc/order_bloc.dart';
import 'package:daprot_seller/bloc/order_bloc/order_events.dart';
import 'package:daprot_seller/bloc/order_bloc/order_states.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/domain/model/order_models.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/order_widgets/product_details_card.dart';
import 'package:daprot_seller/features/widgets/order_widgets/user_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final bool? hasReason;
  final String reason;
  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.hasReason,
    required this.reason,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderStatus _selectedStatus = OrderStatus.pending;
  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    _noScreenshot.screenshotOff();
    // showDailogueConfirm();
    super.initState();
    final bool hasReasonNotNull = widget.hasReason ?? false;
    BlocProvider.of<OrderBloc>(context).add(CheckOrderCancle(
        reason: widget.reason,
        order: widget.order,
        hasReason: hasReasonNotNull));
    // if (hasReasonNotNull && widget.order.orderStatus == 'pending') {
    //   showDialog(
    //     context: context,
    //     builder: (context) => Builder(builder: (context) {
    //       return AlertDialog(
    //         title: const Text('Requested for cancellation'),
    //         content: Text(widget.reason),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               BlocProvider.of<OrderBloc>(context).add(
    //                 UpdateOrderStatus(
    //                   orderId: widget.order.orderId,
    //                   newStatus: 'cancelled',
    //                   userId: widget.order.userId,
    //                 ),
    //               );
    //             },
    //             child: const Text('Confirm'),
    //           ),
    //         ],
    //       );
    //     }),
    //   );
    // }
  }

  // void showDailogueConfirm() async {
  //   final bool hasReasonNotNull = widget.hasReason ?? false;
  //   if (hasReasonNotNull && widget.order.orderStatus == 'pending') {
  //     await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Requested for cancellation'),
  //         content: Text(widget.reason),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               BlocProvider.of<OrderBloc>(context).add(
  //                 UpdateOrderStatus(
  //                   orderId: widget.order.orderId,
  //                   newStatus: 'cancelled',
  //                   userId: widget.order.userId,
  //                 ),
  //               );
  //             },
  //             child: const Text('Confirm'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          LoadingDialog.showLoaderDialog(context);
        }
        if (state is OrderUpdateSuccess) {
          customSnackBar(context, 'Status Updated', true);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (state is OrderUpdateFailure) {
          customSnackBar(context, 'Status Updated Failed', false);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (state is OrderCancelationReq) {
          // showDialog(
          //   context: context,
          //   builder: (context) => Builder(builder: (context) {
          //     return AlertDialog(
          //       title: const Text('Requested for cancellation'),
          //       content: Text(widget.reason),
          //       scrollable: true,
          //       actions: <Widget>[
          //         TextButton(
          //           onPressed: () {
          //             LoadingDialog.showLoaderDialog(context);
          //             BlocProvider.of<OrderBloc>(context).add(
          //               UpdateOrderStatus(
          //                 orderId: widget.order.orderId,
          //                 newStatus: 'cancelled',
          //                 userId: widget.order.userId,
          //               ),
          //             );
          //             Navigator.of(context).pop();
          //           },
          //           child: Text(
          //             'Confirm',
          //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                   color: ColorsManager.primaryColor,
          //                   fontSize: 12.sp,
          //                 ),
          //           ),
          //         ),
          //       ],
          //     );
          //   }),
          // );
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
                if (widget.order.orderStatus != 'pending')
                  Card(
                    elevation: 0.0,
                    child: Text(
                      widget.order.orderStatus.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: ColorsManager.primaryColor),
                    ),
                  ),
                if (widget.order.orderStatus == 'pending' && widget.hasReason!)
                  Card(
                    color: const Color.fromARGB(209, 245, 161, 161),
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Requested For Cancellation:",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 12.sp,
                                      color: ColorsManager.primaryColor,
                                    ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            widget.reason,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          SizedBox(height: 1.h),
                          ElevatedButton(
                            onPressed: () {
                              LoadingDialog.showLoaderDialog(context);
                              BlocProvider.of<OrderBloc>(context).add(
                                UpdateOrderStatus(
                                  orderId: widget.order.orderId,
                                  newStatus: 'cancelled',
                                  userId: widget.order.userId,
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.primaryColor,
                              foregroundColor: ColorsManager.whiteColor,
                            ),
                            child: Text(
                              'Confirm'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 10.sp,
                                      color: ColorsManager.whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.order.orderStatus == 'pending' && !widget.hasReason!)
                  ElevatedButton(
                    onPressed: () async {
                      OrderStatus? selectedStatus =
                          await showDialog<OrderStatus>(
                              context: context,
                              builder: (context) {
                                if (widget.order.orderStatus == 'pending' &&
                                    widget.hasReason!) {
                                  return OrderReqCancle(
                                    order: widget.order,
                                    reason: widget.reason,
                                  );
                                } else {
                                  return _OrderStatusDialog(
                                    orderBloc:
                                        BlocProvider.of<OrderBloc>(context),
                                    order: widget.order,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedStatus = value;
                                      });
                                    },
                                  );
                                }
                              });

                      if (selectedStatus != null) {
                        BlocProvider.of<OrderBloc>(context).add(
                          UpdateOrderStatus(
                            orderId: widget.order.orderId,
                            userId: widget.order.userId,
                            newStatus: selectedStatus.name,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.accentColor),
                    child: Text(
                      widget.order.orderStatus == 'pending' && widget.hasReason!
                          ? "Requested for Cancellation"
                          : widget.order.orderStatus.toUpperCase(),
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

class OrderReqCancle extends StatelessWidget {
  final String reason;
  final OrderModel order;
  const OrderReqCancle({super.key, required this.reason, required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reason for cancellation'),
      content: Text(
        reason,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            LoadingDialog.showLoaderDialog(context);
            BlocProvider.of<OrderBloc>(context).add(
              UpdateOrderStatus(
                orderId: order.orderId,
                newStatus: 'cancelled',
                userId: order.userId,
              ),
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryColor,
            foregroundColor: ColorsManager.whiteColor,
          ),
          child: Text(
            'Confirm',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 9.sp, color: ColorsManager.whiteColor),
          ),
        ),
      ],
    );
  }
}
