import 'package:daprot_seller/bloc/order_bloc/order_events.dart';
import 'package:daprot_seller/bloc/order_bloc/order_states.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository = OrderRepository();

  OrderBloc() : super(const OrderLoading()) {
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CheckOrderCancle>(
      (event, emit) {
        if (event.hasReason && event.order.orderStatus == 'pending') {
          emit(const OrderLoading());
          emit(const OrderCancelationReq());
        }
      },
    );
  }

  void _onUpdateOrderStatus(
      UpdateOrderStatus event, Emitter<OrderState> emit) async {
    try {
      emit(const OrderLoading());
      await orderRepository.updateOrderStatus(
        orderId: event.orderId,
        newStatus: event.newStatus,
        userId: event.userId,
      );
      emit(OrderUpdateSuccess(event.orderId));
    } catch (error) {
      emit(OrderUpdateFailure(error.toString()));
      print(error.toString());
    }
  }
}
