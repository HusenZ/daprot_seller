// import 'package:daprot_seller/bloc/order_bloc/order_events.dart';
// import 'package:daprot_seller/bloc/order_bloc/order_states.dart';
// import 'package:daprot_seller/domain/order_repo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   final OrderRepository orderRepository;

//   OrderBloc(this.orderRepository) : super(const OrderLoading()) {
//     on<FetchOrders>(_onFetchOrders);
//     on<UpdateOrderStatus>(_onUpdateOrderStatus);
//   }

//   void _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
//     try {
//       final orders = await orderRepository.getOrders();
//       emit(OrdersLoaded(orders));
//     } catch (error) {
//       emit(OrderError(error.toString()));
//     }
//   }

//   void _onUpdateOrderStatus(
//       UpdateOrderStatus event, Emitter<OrderState> emit) async {
//     try {
//       await orderRepository.updateOrderStatus(event.orderId, event.newStatus);
//       emit(OrderUpdateSuccess(event.orderId));
//     } catch (error) {
//       emit(OrderUpdateFailure(error.toString()));
//     }
//   }
// }
