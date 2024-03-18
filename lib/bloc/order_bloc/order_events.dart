import 'package:daprot_seller/domain/model/order_models.dart';

abstract class OrderEvent {
  const OrderEvent();
}

class FetchOrders extends OrderEvent {
  const FetchOrders();
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  const UpdateOrderStatus(this.orderId, this.newStatus);
}
