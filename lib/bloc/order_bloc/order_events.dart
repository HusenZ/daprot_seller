import 'package:gozip_seller/domain/model/order_models.dart';

abstract class OrderEvent {
  const OrderEvent();
}

class FetchOrders extends OrderEvent {
  const FetchOrders();
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String userId;
  final String newStatus;

  const UpdateOrderStatus({
    required this.orderId,
    required this.newStatus,
    required this.userId,
  });
}

class CheckOrderCancle extends OrderEvent {
  final String reason;
  final OrderModel order;
  final bool hasReason;

  CheckOrderCancle({
    required this.reason,
    required this.order,
    required this.hasReason,
  });
}
