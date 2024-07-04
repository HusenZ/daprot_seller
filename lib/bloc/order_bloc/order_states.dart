import 'package:daprot_seller/domain/model/order_models.dart';

abstract class OrderState {
  const OrderState();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderStatusLoaded extends OrderState {
  const OrderStatusLoaded();
}

class OrderCancelationReq extends OrderState {
  const OrderCancelationReq();
}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);
}

class OrderUpdateSuccess extends OrderState {
  final String orderId;

  const OrderUpdateSuccess(this.orderId);
}

class OrderUpdateFailure extends OrderState {
  final String error;

  const OrderUpdateFailure(this.error);
}

class OrderError extends OrderState {
  final String error;

  const OrderError(this.error);
}
