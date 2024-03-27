abstract class OrderEvent {
  const OrderEvent();
}

class FetchOrders extends OrderEvent {
  const FetchOrders();
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String newStatus;

  const UpdateOrderStatus({required this.orderId, required this.newStatus});
}
